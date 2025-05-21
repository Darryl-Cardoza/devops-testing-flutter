import 'dart:convert';
import 'dart:io';

void main() async {
  final input = await stdin.transform(utf8.decoder).join();

  if (input.trim().isEmpty) {
    stderr.writeln('Input is empty. No test results to convert.');
    // Output a minimal valid JUnit XML so downstream tools don’t fail
    print('<?xml version="1.0" encoding="UTF-8"?><testsuites></testsuites>');
    exit(0); // Gracefully exit
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

  final testCases = <String, List<Map>>{};

  for (var e in events) {
    if (e['type'] == 'testDone') {
      final name = e['name'] ?? 'unknown';
      final status = e['result'] ?? 'unknown';
      final suite = e['suite'] ?? 'default';
      testCases.putIfAbsent(suite.toString(), () => []).add({
        'name': name,
        'status': status,
      });
    }
  }

  final buffer = StringBuffer();
  buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
  buffer.writeln('<testsuites>');

  testCases.forEach((suite, cases) {
    buffer.writeln('  <testsuite name="$suite" tests="${cases.length}">');
    for (var test in cases) {
      buffer.write('    <testcase name="${test['name']}">');
      if (test['status'] != 'success') {
        buffer.writeln('<failure message="${test['status']}"/>');
      }
      buffer.writeln('</testcase>');
    }
    buffer.writeln('  </testsuite>');
  });

  buffer.writeln('</testsuites>');
  print(buffer.toString());
}
