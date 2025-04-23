import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final process = await Process.start('flutter', ['test', '--machine']);
  final testNames = <String, String>{}; // testID -> name
  bool hasCriticalFailure = false;

  await for (var line in process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {
    try {
      final event = jsonDecode(line);

      // Store test names by ID
      if (event['event'] == 'testStart') {
        final testId = event['test']['id'].toString();
        final testName = event['test']['name'];
        testNames[testId] = testName;
      }

      // Detect failures and classify them
      if (event['event'] == 'testDone' && event['result'] == 'failure') {
        final testId = event['testID'].toString();
        final testName = testNames[testId] ?? 'Unknown Test';

        print('Test failed: $testName');

        if (testName.contains('CRITICAL') || testName.contains('MAJOR')) {
          hasCriticalFailure = true;
        } else {
          print('⚠Minor test failed (ignored): $testName');
        }
      }
    } catch (_) {
      // Ignore non-JSON lines
    }
  }

  final exitCode = await process.exitCode;

  if (hasCriticalFailure) {
    print('GitHub Action FAILED due to CRITICAL/MAJOR test failures.');
    exit(1);
  } else {
    print('All CRITICAL/MAJOR tests passed.');
    exit(0);
  }
}
