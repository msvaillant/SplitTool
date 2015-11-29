import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as Path;

import 'helper.dart';

main(List<String> args) {
  var parser = new ArgParser()
    ..addOption("target", abbr:  "t", help:  "Used to specify the path to th folder to work with", valueHelp:"path")
    ..addOption("destination", abbr: "d", help: "Used to specify the path to place the moved files, is required", valueHelp:"path")
    ..addOption("filter", abbr: "f", help: "Specifies the mask for files to move", defaultsTo: "*.*")
    ..addOption("attribute", abbr: "a", help: "Is used to specify which kind of files system objects to select (for example Hidden)",allowed: ["h", "n"] ,
        allowedHelp:
        {
          "h": "Hidden files",
          "n": "Normal files (default option)"
        })
    ..addFlag("recurse", abbr: "r", help: "Specifies if it is needed to look throuh the nested folders", defaultsTo: false)
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

String Split(String target, String destination, RegExp filter,
    String attribute, bool recurse, bool suppress)
{
  var files = GetFiles(target, filter, attribute, recurse);
  List<String> movedFiles = new List<String>();
  
  for (var file in files) 
  {
    String destFile = Path.join(destination, Path.basename(file));
    bool process = true;
    //This peace of code could be simplified, maybe. It is needed to find how to make it easy.
    if (FileSystemEntity.isFileSync(destFile))
    {
      if(suppress){
        new File(destFile).deleteSync();
      }
      else{
        stdout.writeln("Do you want to overwrite the file $destFile\n[Y]es or [N]o");
        
        String key = stdin.readLineSync();
        if (key == "Y"){
          new File(destFile).deleteSync();
        }
        else{
          process = false;
        }
      }
    }
    
    if(process)
    {
      new File(file).renameSync(destFile);
      movedFiles.add(Path.basename(file));
    }
  }
  
  return movedFiles.join("\n");
}
