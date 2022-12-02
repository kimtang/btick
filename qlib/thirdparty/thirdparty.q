
d) module
 thirdparty
 Library to integrate 3rd party modules. Here we are using yq to parse yaml files.
 q).import.module`thirdparty

.thirdparty.summary:{
 / test if yq is available
 }

d) function
 rlang
 .thirdparty.summary
 Function to give a sumnmary of the available third parties modules here
 q) .thirdparty.summary[]
 q) .thirdparty.summary`

.thirdparty.ytok:{[filePath]
 if[10 = abs type filePath;filePath:`$filePath];
 if[":"=first string filePath;filePath:`$1_string filePath];
 .j.k "\n"sv system .bt.print["yq -P %0 -o json"] 1#filePath
 }

d) function
 thirdparty
 .thirdparty.ytok
 Function to parse a yaml file to k object.
 q) .thirdparty.ytok `$":C:\\dev\\main\\src\\qlib\\life\\life.yml"




