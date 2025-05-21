import 'dart:convert';
import 'dart:io';
import 'package:html_unescape/html_unescape.dart';

final htmlEscape = const HtmlEscape();

void main() async {
  final inputLines = await stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .toList();

  if (inputLines.isEmpty) {
    stderr.writeln('Input is empty. No test results to convert.');
    stdout.writeln('<?xml version="1.0" encoding="UTF-8"?><testsuites></testsuites>');
    await stdout.flush();
    exit(0);
  }

  final events = inputLines
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
          testMetadata[test['id']] = {
            'name': test['name'],
            'suite': test['suiteID'],
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
          testMetadata[id]['logs'].add(message.toString());
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

          final suite = meta['suite'].toString();
          testResults.putIfAbsent(suite, () => []).add({
            'name': meta['name'],
            'status': e['result'],
            'time': duration.toStringAsFixed(3),
            'logs': meta['logs'].join('\n'),
          });
        }
        break;
    }
  }

  final buffer = StringBuffer();
  buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
  buffer.writeln('<testsuites>');

  testResults.forEach((suite, cases) {
    buffer.writeln('  <testsuite name="Suite $suite" tests="${cases.length}">');
    for (var test in cases) {
      final testName = htmlEscape.convert(test['name']);
      final testTime = test['time'];
      final status = htmlEscape.convert(test['status']);
      final logs = test['logs'] ?? '';

      buffer.write('    <testcase name="$testName" time="$testTime">');

      if (status != 'success') {
        final escapedLogs = logs.replaceAll(']]>', ']]]]><![CDATA[>'); // Safe CDATA
        buffer.writeln('<failure message="$status"><![CDATA[$escapedLogs]]></failure>');
      }

      buffer.writeln('</testcase>');
    }
    buffer.writeln('  </testsuite>');
  });

  buffer.writeln('</testsuites>');

  stdout.writeln(buffer.toString());
  await stdout.flush(); // Ensure all output is written before exiting
}
