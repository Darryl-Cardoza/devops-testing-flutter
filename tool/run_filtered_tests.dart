import 'dart:io';
import 'package:xml/xml.dart';

Future<void> main() async {
  final xmlFile = File('test-results/test-report.xml');

  if (!xmlFile.existsSync()) {
    print('Test report not found.');
    exit(1);
  }

  final document = XmlDocument.parse(await xmlFile.readAsString());
  final failedTests = document.findAllElements('testcase')
      .where((testcase) => testcase.findElements('failure').isNotEmpty || testcase.findElements('error').isNotEmpty);

  bool hasCriticalFailure = false;

  for (final test in failedTests) {
    final name = test.getAttribute('name') ?? '';

    if (name.contains('CRITICAL') || name.contains('MAJOR')) {
      hasCriticalFailure = true;
      print('Critical test failed: $name');
    } else {
      print('Minor test failed (ignored): $name');
    }
  }

  if (hasCriticalFailure) {
    print('GitHub Action FAILED due to CRITICAL/MAJOR test failures.');
    exit(1);
  } else {
    print('All CRITICAL/MAJOR tests passed.');
    exit(0);
  }
}
