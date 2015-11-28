import 'dart:io';
import 'package:path/path.dart' as Path;

String GetInfo(String target, RegExp filter, String attribute, bool recurse)
{
  return GetFiles(target, filter, attribute, recurse).join("\n");
}

List<String> GetFiles(String target, RegExp filter, String attribute, bool recurse)
{
  var items = new Directory(target).listSync(recursive:recurse, followLinks: false)
    ..retainWhere((file) => file is File);
  
  List<String> files = new List<String>();
  for(var file in items)
  {
    String fileName = Path.basename(file.path);
    if(filter.hasMatch(fileName))
      files.add(fileName);
  }
  return files;
}

RegExp FromWildCardToRegExp(String wildCard)
{
  return new RegExp(r'^' + wildCard.replaceAll("*", r".*").replaceAll(r"?", ".") + r'$', caseSensitive: false);
}

List<String> Split(String target, String destination, RegExp filter, String attribute, bool recurse, bool suppress)
{
  
}