import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('test-results/results.json');
  final contents = await file.readAsString();
  final testResults = json.decode(contents);

  bool failedCriticalTests = false;

  // Iterate over all the test results and check severity
  for (var test in testResults) {
    if (test['severity'] == 'CRITICAL' && test['status'] == 'FAILED') {
      failedCriticalTests = true;
      print('Critical Test Failed: ${test['name']}');
    } else if (test['severity'] == 'MINOR' && test['status'] == 'FAILED') {
      // Minor test failures can be skipped
      print('Minor Test Failed (skipped for now): ${test['name']}');
    }
  }

  if (failedCriticalTests) {
    exit(1);
  }

  exit(0);
}
