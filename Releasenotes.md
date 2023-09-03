# Version 1.3.5
+ Fixed AVX512 detection on Windows
+ Fixed Thread Settings from Portal
+ Automatic runner selection from Portal Settings
+ Automatic thread selection from Portal Settings

# Version 1.3.4
+ New Setting: `"useAvx": true` which forces the client to use AVX2 runner
+ New Setting: `"allowHwInfoCollect": true` which will allow the client to collect CPU Model, RAM Size and CPU Cache Size; with this information the client can better decide which runner should be used
+ Optimized Detection of AVX2/512
+ Optimized Error Handling

# Version 1.3.0
+ Added automated selection of AVX2/512 runner

# Version 1.2.3
+ New Setting: `"customRunner": true` to enforce a [custom runner](CustomRunner.md)
