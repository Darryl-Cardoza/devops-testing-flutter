import 'dart:convert';
import 'dart:io';

void main() async {
  final input = await stdin.transform(utf8.decoder).join();

  if (input.trim().isEmpty) {
    stderr.writeln('Input is empty. No test results to convert.');
    print('<?xml version="1.0" encoding="UTF-8"?><testsuites></testsuites>');
    exit(0);
  }

  final events = LineSplitter.split(input)
      .where((line) => line.trim().isNotEmpty)
      .map((line) {
    try {
      return json.decode(line);
    } catch (_) {
      return null;
    }
  })
      .whereType<Map>()
      .toList();

  final testMetadata = <int, Map>{}; // testID -> test metadata
  final testResults = <String, List<Map>>{}; // suiteID -> list of test results

  for (var e in events) {
    switch (e['type']) {
      case 'testStart':
        final test = e['test'];
        if (test != null) {
          final suiteID = test['suiteID']?.toString() ?? 'unknown';
          testMetadata[test['id']] = {
            'name': test['name'],
            'suite': suiteID,
            'url': test['url'],
            'startTime': e['time'],
            'logs': <String>[],
          };
        }
        break;

      case 'print':
      case 'error':
      case 'message':
        final id = e['testID'];
        if (testMetadata.containsKey(id)) {
          final message = e['message'] ?? e['error'] ?? '';
          final logs = testMetadata[id]['logs'] as List<String>;
          logs.add(message.toString());
        }
        break;

      case 'testDone':
        final id = e['testID'];
        final meta = testMetadata[id];
        if (meta != null) {
          final endTime = e['time'];
          final duration = meta['startTime'] != null
              ? (endTime - meta['startTime']) / 1000.0
              : 0.0;

          final url = meta['url'] ?? '';
          final suiteName = url.toString().split(Platform.pathSeparator).last;
          testResults.putIfAbsent(suiteName, () => []).add({
            'name': meta['name'],
            'status': e['result'],
            'time': duration.toStringAsFixed(3),
            'logs': (meta['logs'] as List<String>).join('\n'),
          });
        }
        break;
    }
  }

  final buffer = StringBuffer();
  buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
  buffer.writeln('<testsuites>');

  testResults.forEach((suite, cases) {
    buffer.writeln('  <testsuite name="$suite" tests="${cases.length}">');
    for (var test in cases) {
      final testName = _xmlEscape(test['name']);
      final testTime = test['time'];
      buffer.write('    <testcase name="$testName" time="$testTime">');

      if (test['status'] != 'success') {
        final logs = _xmlEscape(test['logs'] ?? 'Test failed');
        buffer.writeln('<failure message="${test['status']}"><![CDATA[$logs]]></failure>');
      }

      buffer.writeln('</testcase>');
    }
    buffer.writeln('  </testsuite>');
  });

  buffer.writeln('</testsuites>');
  print(buffer.toString());
}

String _xmlEscape(String? input) {
  return input
      ?.replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;') ?? '';
}
