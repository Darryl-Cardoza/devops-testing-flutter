import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final process = await Process.start('flutter', ['test', '--machine']);
  bool hasCriticalFailure = false;

  await for (var line in process.stdout.transform(utf8.decoder).transform(const LineSplitter())) {
    try {
      final json = jsonDecode(line);
      if (json['type'] == 'testDone' &&
          json['result'] == 'failure' &&
          json.containsKey('name')) {
        final testName = json['name'] as String;
        print('Test failed: $testName');

        if (testName.contains('CRITICAL') || testName.contains('MAJOR')) {
          hasCriticalFailure = true;
        }
      }
    } catch (_) {
      // Not all lines are JSON; ignore them
    }
  }

  final exitCode = await process.exitCode;

  if (hasCriticalFailure || exitCode != 0) {
    print('GitHub Action FAILED due to CRITICAL/MAJOR test failures.');
    exit(1);
  } else {
    print('All CRITICAL/MAJOR tests passed.');
    exit(0);
  }
}
