# Version 1.5.4
+ fixed bug with Qiner communication protocol
  
# Version 1.5.2
+ fixed bug which decreases training performance over time
  
# Version 1.5.2
+ Optimized Communication between Client and API
+ Fixed blocking Bug
+ Deprecated: `"AVX2":true` setting
+ Optimized Detection of AVX512 and added Fallback to AVX2
+ Removed Deprecated Settings
+ Added Setting `AllowOptimization` to allow the trainer to try to optimize environment. (Default: false)
+ Reduced Runner Footprint

# Version 1.4.2
+ Bugfixing
+ Automatic optimization of the environment

# Version 1.4.0
+ Bugfixing
+ Possibility to Overwrite Params like AVX512
+ new argument `--version` to get current version of Client

# Version 1.3.9
+ Bugfixing
+ New Setting: `"serviceLock": true` to use qiner protocol for custom runner
+ New Log Format with display of average it/s
+ Signaling if the trainer isn't starting properly
  
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
