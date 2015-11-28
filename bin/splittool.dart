import 'dart:io';
import 'package:args/args.dart';

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
    ..addFlag("info", abbr: "i", help: "Shows the files in target path that will be transfered. According to the specified filters.", defaultsTo: false)
    ..addFlag("help", abbr:"h", help: "Shows usage information");
  
  var results = parser.parse(args);
  var targetPath = results["target"];
  var destinationPath = results["destination"];
  var filter = results["filter"];
  var attribute = results["attribute"];
  bool recurse = results["recurse"];
  bool suppress = results["suppress"];
  
  if(results["help"]){
    stdout.writeln(parser.usage);
    exit(0);
  }
  
  if(results["info"]){
    print(GetInfo());
    exit(0);
  }
  Map env = Platform.environment;
  if(env["COPYCMD"]!= null)
    suppress = env["COPYCMD"] == "/Y";
  
  int validationResult = Validate(targetPath, destinationPath);
  if(validationResult == 0)
    Split(targetPath, destinationPath, attribute, filter, recurse, suppress);
  
  
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
  
  return 0;
}

List<String> GetInfo()
{
  
}

List<String> Split(String target, String destination, String filter, String attribute, bool recurse, bool suppress)
{
  
}