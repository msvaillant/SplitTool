import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as Path;

main(List<String> args) {
  var parser = new ArgParser()
    ..addOption("target", abbr:  "t", help:  "Used to specify the path to th folder to work with", valueHelp:"path", defaultsTo: "")
    ..addOption("destination", abbr: "d", help: "Used to specify the path to place the moved files, is required", valueHelp:"path")
    ..addOption("filter", abbr: "f", help: "Specifies the mask for files to move", defaultsTo: "*.*")
    ..addOption("attribute", abbr: "a", help: "Is used to specify which kind of files system objects to select (for example Hidden)",allowed: ["h", "n"] ,
        allowedHelp:
        {
          "h": "Hidden files",
          "n": "Normal files (default option)"
        })
    ..addFlag("recurse", abbr: "r", help: "Specifies if it is needed to look throuh the nested folders", defaultsTo: false, negatable: false)
    ..addFlag("suppress", abbr: "s", help: "Specifies if it is needed to ask for overwriting existing files in destinatino folder", defaultsTo: false, negatable: true)
    ..addFlag("dry-run", help: "Shows the files in target path that will be transfered. According to the specified filters.", defaultsTo: false)
    ..addFlag("help", abbr:"h", help: "Shows usage information");
  
  var results = parser.parse(args);
  String targetPath = results["target"];
  String destinationPath = results["destination"];
  String filter = results["filter"];
  String attribute = results["attribute"];
  bool recurse = results["recurse"];
  bool suppress = results["suppress"];
  
  var regex = FromWildCardToRegExp(filter);
  
  if(results['help']){
    stdout.writeln(parser.usage);
    exit(0);
  }
  
  if(results['dry-run']){
    stdout.writeln(GetInfo(targetPath, regex, attribute, recurse));
    exit(0);
  }
  Map env = Platform.environment;
  if(env['COPYCMD']!= null)
    suppress = env['COPYCMD'] == r'/Y';
  
  int validationResult = Validate(targetPath, destinationPath);
  if(validationResult == 0)
    stdout.writeln(Split(targetPath, destinationPath, regex, attribute,  recurse, suppress));
    
  exit(validationResult);
}

int Validate(String target, String destination)
{
  if(target == null){
    stderr.writeln("An error occured, the target must be set");
    return 2;
  }
  
  if(destination == null){
    stderr.writeln("An error occured, the destination must be set");
    return 2;
  }
  
  if(!(new Directory(target).existsSync()))
  {
    stderr.writeln("An error occured, the $target folder doesn't exist. Check path.");
    return 2;
  }
  
  if(!(new Directory(destination).existsSync()))
  {
    stderr.writeln("An error occured, the $destination folder doesn't exist. Check path.");
    return 2;
  }
  
  return 0;
}

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