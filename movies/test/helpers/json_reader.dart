import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('\\movies')) {
    dir = dir.replaceAll('\\movies', '');
  } else if (dir.endsWith('/movies')) {
    dir = dir.replaceAll('/movies', '');
  }
  return File('$dir/movies/test/$name').readAsStringSync();
}
