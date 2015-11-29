import 'dart:io';
import 'package:path/path.dart' as Path;

String GetInfo(String target, RegExp filter, String attribute, bool recurse) {
  return GetFiles(target, filter, attribute, recurse).join("\n");
}

List<String> GetFiles(String target, RegExp filter, String attribute, bool recurse) {  
  var items = new Directory(target)
    .listSync(recursive: recurse, followLinks: false)
    ..retainWhere((file) => file is File)
    ..retainWhere((entity) => filter.hasMatch(Path.basename(entity.path)));

  
  //There must be selection of files by attributes, or before items selection (depends on realisation)
  List<String> files = new List<String>();
  for (var file in items)
    files.add(file.path);
  
  return files;
}

RegExp FromWildCardToRegExp(String wildCard) {
  return new RegExp( r'^' + 
      wildCard
      .replaceAll("*", r".*")
      .replaceAll(r"?", ".") + r'$',
      caseSensitive: false);
}


