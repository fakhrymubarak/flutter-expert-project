import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('\\tv_shows')) {
    dir = dir.replaceAll('\\tv_shows', '');
  } else if (dir.endsWith('/tv_shows')) {
    dir = dir.replaceAll('/tv_shows', '');
  }
  return File('$dir/tv_shows/test/$name').readAsStringSync();
}
