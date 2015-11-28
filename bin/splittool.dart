import 'dart:io';
import 'package:args/args.dart';

main(List<String> args) {
  var parser = new ArgParser(); 
  parser
    ..addOption("target", abbr:  "t", help:  "Used to specify the path to th folder to work with", valueHelp:"path", defaultsTo: "")
    ..addOption("destination", abbr: "d", help: "Used to specify the path to place the moved files, is required", valueHelp:"path")
    ..addOption("filter", abbr: "f", help: "Specifies the mask for files to move", defaultsTo: "*.*")
    ..addOption("attribute", abbr: "a", help: "Is used to specify which kind of files system objects to select (for example Hidden)",allowed: ["h", "n"] ,
        allowedHelp:
        {
          "h": "Hidden files",
          "n": "Normal files (default option)"
        })
    ..addFlag("recurse", abbr: "r", help: "Specifies if it is needed to look throuh the nested folders", defaultsTo: false, negatable: true)
    ..addFlag("suppress", abbr: "s", help: "Specifies if it is needed to ask for overwriting existing files in destinatino folder", defaultsTo: false, negatable: true)
    ..addFlag("info", abbr: "-i", help: "Shows the files in target path that will be transfered. According to the specified filters.", defaultsTo: false);
  
}
