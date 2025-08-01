import 'dart:io';

String fixture(String name) {
  return File('lib/test/fixtures/$name').readAsStringSync();
}