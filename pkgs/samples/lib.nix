{ lib, runCommand, pspsdk, buildSample, ... }:

let
  fileList = lib.splitString "\n" (lib.readFile
    (runCommand "test" { preferLocalBuild = true; } ''
      cd ${pspsdk}/psp/sdk/samples
      find . -name Makefile -exec dirname {} \; > $out
    ''));
  merge = builtins.foldl' (a: b: lib.recursiveUpdate a b) { };
in merge (lib.lists.forEach fileList (x:
  let
    items = (lib.splitString "/" x);
    length = lib.length items;
    result = (if length == 3 then {
      "${lib.elemAt items 1}" = { 
        "${lib.elemAt items 2}" = buildSample {
          name = lib.elemAt items 2;
          src = "./${lib.elemAt items 1}/${lib.elemAt items 2}";
        };
      };
    } else if length == 2 then {
      "${lib.elemAt items 1}" = buildSample {
        name = lib.elemAt items 1;
        src = "${pspsdk}/psp/samples/${lib.elemAt items 1}";
      };
    } else
      { });
  in result))
