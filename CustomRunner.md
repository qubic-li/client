# QLI Custom Runner (DRAFT!)
You have the possibility to use your own runner. A runner in our terms is a worker process which does the AI training. By Default, qli-Client checks your local configuration and loads the current runner for the acutal epoch and starts this as a worker process as needed.
A custom runner is useful if you code your own trainer or if you want to experiment.

1. [Prerequisites](#prerequisites)
2. [Communication](#communication)
3. [Qubic/Qiner Protocol](#qubicqiner-protocol)
   1. [Command Line Arguments](#command-line-arguments-qiner)
   2. [STDOUT](#stdout-qiner) 

## Why do i need to run the qli-Client?
The `qli-Client` ensures a secure communcation with the qli backend API. The `qli-Client` takes care that you always run on the correct ID and reports the current state of the worker.
Without prior authorization, it is not allowed to use a custum Client for the communication with the API.

By Default, the Client transmits the following information to the backend:
- Current Training Task Information (ID, it/s)
- Solutions
- CPU Capability: AVX2/AVX512
- OS: Windows, Linux, OSX
- Alias: The name of the client instance

## Prerequisites
You need the `qli-Client` Version `1.3.9` or greater to use all the described options.

The Configuration Options for a custom runner are:

|  Option 	|  Default Value 	|  Description 	|
|---	|---	|---	|
| customRunner | false | Set this to true to use your custom runner |
| trainerBinary | "qli-runner" | With this option you can change the name of the runner. |
| serviceLock | false | Set this to `true` if you want to use Qiner as a runner |

To use your own runner, set `customRunner` to `true`.

## Communication
For the communication between the runner and the client you can use the standard Qubic/Qiner protocol:
The `qli-Client` starts the worker process and observes it's `STDOUT`.

## Qubic/Qiner Protocol
With this, your custom runner just needs to behave like the official Qiner from Qubic. (https://github.com/Qubic-World/qubic-miner-cpu)

> **Important**: the `stdout` needs to be flushed regularly. In C++ you can use `fflush(stdout);` after every printout of the current state. (In Orignal Qunier this is right after `printf("|   %d-%d%d-%d%d %d%d:%d%d:%d%d   |   %d it/s   |   %d solutions   |   %.10s...   |\n", systemTime.wYear, systemTime.wMonth / 10, systemTime.wMonth % 10, systemTime.wDay / 10, systemTime.wDay % 10, systemTime.wHour / 10, systemTime.wHour % 10, systemTime.wMinute / 10, systemTime.wMinute % 10, systemTime.wSecond / 10, systemTime.wSecond % 10, (numberOfMiningIterations - prevNumberOfMiningIterations) * 1000 / delta, numberOfFoundSolutions, argv[2]);`)

If you use the Qiner protocol you can run only one instance of `qli-Client` per maschine.
 
> **Limitation**: only one instance of `qli-Client` can run with Quiner protocol

### Command Line Arguments Qiner
Your runner must accept the following commands:
`<IP> <ID> <NUMBEROFTHREADS`
where
- <IP> will be the IP Address to report the found solution to
- <ID> The Identity/ID to use for the training
- <NUMBEROFTHREADS> The Number of Threads to be used for the training

### STDOUT Qiner
Your custom runner must ouput at least the following:

- `X solutions` => `X` ist the amount of found solutions
- `Y it/s` => `Y` are the current iterations per seconds

> these two parameters will be parsed by the client and displayed in the unified qli format. Including an average of it/s over the last 100 messages.

### Solution Deliviery
Use the standard Quiner protocol.

