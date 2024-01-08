# Version 1.8.3
+ Fixed a bug in calculating local found solutions. (e.g. wrong "SOL: 12/300" display)
+ Fiexd a reporting bug
+ Added experimental display of epoch to console output
  
# Version 1.8.2
+ Fixed a bug in writing `stats.EPOCH.lock` file
  
# Version 1.8.1
+ Added optimized console logging. (new format: "SOL: X/Y" where Y is found solutions and X is submitted solutions)

# Version 1.8.0
+ GPU Release

# Version 1.7.6
+ Fixed Bug where solution finding was delayed
+ Changed main communication Scheme from qiner to qli internal
  
# Version 1.7.5
+ Windows Release
+ Bugfixes

# Version 1.7.3
+ UPgrade from .Net 6 to 7
+ Added Intel Skylake detection for Linux
  
# Version 1.7.2
+ Downgrade from .Net 7 to 6
+ Removed AVX2 Fallback for Linux
  
# Version 1.7.1
+ Optimized Network Traffic Handling
+ Significant performance boost

# Version 1.7.0
+ Fixed Bug in Solution Delivery in certain environments
+ Added compatibility for new Qubic protocol
  
# Version 1.6.1
+ Fixed potential Bug in Solution Delivery
+ Added http/2 support
  
# Version 1.6.0
+ Improved API Handling
+ General Bugfixing
+ Added/Updated Qiner Protocol
  
# Version 1.5.5
+ fixed bug on Windows with stopping to report status
+ automatic fallback to AVX2 on linux
+ DEPRECATED: custom QLI Protocol

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
