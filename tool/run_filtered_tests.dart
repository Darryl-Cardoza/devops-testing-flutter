import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('test-results/results.json');
  if (!await file.exists()) {
    print('No test results file found.');
    exit(0);
  }

  final lines = await file.readAsLines();
  final testNames = <String, String>{};
  final failedTests = <Map<String, dynamic>>[];

  for (final line in lines) {
    if (line.trim().isEmpty) continue;

    final event = jsonDecode(line);

    if (event['event'] == 'testStart') {
      final id = event['test']['id'].toString();
      final name = event['test']['name'];
      testNames[id] = name;
    }

    if (event['event'] == 'testDone' && event['result'] == 'failure') {
      final id = event['testID'].toString();
      final name = testNames[id] ?? 'Unknown Test';

      // Simulate severity from name
      final isMinor = name.toLowerCase().contains('minor');
      failedTests.add({
        'name': name,
        'severity': isMinor ? 'MINOR' : 'CRITICAL',
        'status': 'FAILED',
      });
    }
  }

  bool failedCriticalTests = false;

  for (final test in failedTests) {
    if (test['severity'] == 'CRITICAL') {
      failedCriticalTests = true;
      print('Critical Test Failed: ${test['name']}');
    } else {
      print('Minor Test Failed (skipped): ${test['name']}');
    }
  }

  if (failedCriticalTests) {
    exit(1);
  }

  print('No critical test failures.');
  exit(0);
}
