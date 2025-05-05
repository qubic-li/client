# QLI qubic.li - Client

This is the main client component from qubic.li. It connects to the backend API and receives tasks to perform.

The Client runs on Docker, Windows and Linux. Below you find the instructions how to use it.

1. [Security Warning](#security-warning)
2. [Pool Mining](#pool-mining)
3. [Download](#download)
4. [What's needed](#whats-needed)
5. [Windows](#windows)
6. [Docker: Run qli-Client with Docker](#docker)
7. [Linux Option 1: Run qli-Client in a Linux Screen](#linux-option-1-screen-session)
8. [Linux option 2: Run qli-Client as Linux Service (Expert)](#linux-option-2-expert-systemd-linux-service)  
   a. [Ubuntu 22.04](#ubuntu-2204)     
   b. [Debian 12](#debian-12)  
   d. [Monitoring](#service-monitoring)  
   e. [Remove Client](#remove-client) 
9. [HiveOs](#hiveos)
10. [Appsettings.json Customization](#customizing)
11. [Trainer Options](#trainer-options)
12. [Idling Options](#idle-options) 
12. [XMR Options](#xmr-options) 
13. [Troubleshooting](#troubleshooting)

## Security Warning
The client is able to download runners, which then performs the AI Training tasks. This can potentially be used in a bad manner. Run the client with the least priviliges which are possble. e.g. on windows NOT as Admininstrator; on linux NOT as root.

Find more information about the "principle of least privilege" on wikipedia: https://en.wikipedia.org/wiki/Principle_of_least_privilege

## Pool Mining
If you don't want to operate your own Qubic infrastructure. You can join the QLI (qubic.li) pool mining. You can either register an account (**highly recomended**) on http://pool.qubic.li or you can join pool mining register-less.

The simplest way to join is to create an account and login to https://pool.qubic.li, follow the instructions after you have logged in there.

### PPS+ vs Solo
With the QLI pools you can choose between PPS (Pay Per Share) or solo training. With PPS you avoid the own volatility which is useful for smaller environments. It is also allowed to run some workers as PPS and others as solo training where you will see revenue only when you find valid Qubic Solutions.

To Enable/Disable PPS use either `"pps": true` or `"pps": false` in your settings.

### Client Configuration
We recommend to use our Client Setup Configurator: https://pool.qubic.li/en-US/setup

### Registerless training
If you want registration-less pool mining, do the following:
1. Create a Qubic Id (e.g. on https://wallet.qubic.org)
2. Download Client from below or run a Docker
3. Start your Client
```bash
# replace in the examples:
# <QUBICID> with your Qubic Address
# <THREADS> with the amount of threads you want to run training

# bash/shell/command line
./qli-Client --ClientSettings:QubicAddress=<QUBICID> --ClientSettings:Trainer:CpuThreads=<THREADS>

# docker cpu only
docker run --name qli-client -e ClientSettings__QubicAddress=<QUBICID>   -e ClientSettings__Alias= -e ClientSettings__Trainer__CpuThreads=<THREADS>  qliplatform/qubic-client:latest

# docker cpu + gpu
docker run --name qli-client -e ClientSettings__QubicAddress=<QUBICID>   -e ClientSettings__Alias= -e ClientSettings__Trainer__CpuThreads=<THREADS>  qliplatform/qubic-client:cuda

# to use appsettings.json see below
```
4. Check your performance: https://pool.qubic.li (Login with Qubic Address)

You can also put your Qubic Address into the [configuration file](#customizing) if you don't want to use command line arguments.

## Download
We recommend to update your Version if there is a change in the Minor Version (e.g. from 1.3 to 1.4).
Bugfix releases (e.g. from 1.3.1 to 1.3.2) are optional.


### QLI Client
The QLI Client is the pool client and connects to the pool.

| OS |  Platform 	|  Version  | Download  | Description
|--- |---	|---	|--- |---	|
| Windows | x64	| 3.3.7 | https://dl.qubic.li/downloads/qli-Client-3.3.7-Windows-x64.zip  | Includes XMR
| Linux | x64	| 3.3.7 | https://dl.qubic.li/downloads/qli-Client-3.3.7.1-Linux-x64.tar.gz | Includes XMR
| HiveOs | x64	| 3.3.6 | [HiveOs Instructions](https://github.com/qubic-li/hiveos) | 

> Qubic XMR Version for the Qubic Monero POC during idle phase. It uses CPU only. You can still use the [Qubic idling](#idle-options) to run another program/software.
> For XMR mining, the configured amount of CPU threads apply.

### QLI Trainer
The trainer/worker is the binary executable which is responsible for the training. The Trainer is automatically downloaded by the Client. This ensures, that you always have the latest updates and the most optimized training experience.

#### QLI Trainer Options
The following table shows the available trainers.

|  Type 	|   Version Key (`gpuVersion`/`cpuVersion`)	|   Description	|  
|---	|---	|--- |
|   GPU	|  `CUDA`  	|   CUDA Version for all GPU's |
|   GPU	|  `AMD`  	|   General AMD Version (may not be available all the time; depends on the epoch) |
|   CPU	|  `GENERIC`  	|   Generic x64 CPU trainer (no specific instructions needed) |
|   CPU	|  `AVX2`  	|   AVX2 x64 CPU trainer (AVX2 instructions needed) |
|   CPU	|  `AVX512`  	|   AVX512 x64 CPU trainer (AVX512 instructions needed) |
|   CPU	|  `SKYLAKE`  	|   For specific Intel Lake processors (may not be available all the time) |

## What's needed
The runner on Windows also requires the VC Redistributable, which can be obtained from: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170

The runner on linux needs at least **GLIBC 2.31**.

### Huge Pages
Depending on your environment you might want to enable huge pages. This can increase your iterations per second.

The trainer will tell you what is the optimal setting when it detects a wrong value.
```bash
2024-03-16 11:34:13     INFO    Trainer: WARNING: Free number of hugepages is smaller than needed, have: 10 - want: 1612 (52 x number of threads). Falling back to use malloc memory.
2024-03-16 11:34:13     INFO    Trainer: To add more hugepages, please run this command as root before starting the miner
2024-03-16 11:34:13     INFO    Trainer: /usr/sbin/sysctl -w vm.nr_hugepages=1612
2024-03-16 11:34:13     INFO    Trainer: OR: /sbin/sysctl -w vm.nr_hugepages=1612
```

if you see this, you can run the command `/usr/sbin/sysctl -w vm.nr_hugepages=1612` as root or `sudo /usr/sbin/sysctl -w vm.nr_hugepages=1612`


## Command Line Arguments vs. Configuration
You can either start the Client by providing command line arguments or using an [appsettings.json](#customizing) file.

Every setting can be translated into a command line argument, below some examples:

|  Setting 	|  Command Line Argument 	|  Description 	|
|---	|---	|---	|
| `AccessToken`	| `--ClientSettings:AccessToken`	| The Access Token to use |
| `Trainer.CpuThreads`	| `--ClientSettings:Trainer:CpuThreads`	| How many threads should the trainer for CPU use	|
| `Alias`	| `--ClientSettigns:ALias`	| The Alias/Name of your rig/worker. Leave it empty to use machinename |

Sample call: `./qli-Client --ClientSettings:QubicAddress=IERULKJFHESLKJSLDFHZLKSUHLSKDHFLSDF --ClientSettings:Trainer:CpuThreads:16`

## Windows
You can run the client directly on Windows. Open a command console and start it with `./qli-Client.exe` or double click the file when you have the file `appsettings.json` in the same folder.

Download the Client from the above link. The Client must not be installed.

## Docker
We provide two prepared docker images for you:

1. Any CPU: `docker pull qliplatform/qubic-client:latest`
2. NVIDIA/CUDA GPU +  Any GPU: `docker pull qliplatform/qubic-client:cuda`

To start a docker container, you need to pass your configuration either via Environment veriables or you can map your `appsettings.json` into your container.

### Environment Variables
Every setting can be translated into a environment variable, below some examples:

|  Setting 	|  Env Variable 	|  Description 	|
|---	|---	|---	|
| `AccessToken`	| `ClientSettings__AccessToken`	| The Access Token to use	|
| `Trainer.CpuThreads`	| `ClientSettings__Trainer__CpuThreads`	| How many threads should the trainer for CPU use	|
| `Alias`	| `ClientSettigns__ALias`	| The Alias/Name of your rig/worker. Leave it empty to use machinename |

### Mapping appsettings.json
The path inside the container is `/app/appsettings.json`.

### Starting Container

```bash
# start client for cpu training
docker run --name qli-client -e ClientSettings__AccessToken=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImUxODc5YzQ3LTIwZjUtNDA5Yy05MThkLTRhYzgyNzFiYjYxMSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNTE5NzA5NSwiZXhwIjoxNzU2NzMzMDk1LCJpYXQiOjE3MjUxOTcwOTUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.hBYWpMvvpj8N-t6r6iIdF5y8ayKxtSi0FEb689oOrbPiwBrs76MBvpva7mbOQslzuEFJ8jZSFHlD1QgR6P9YMcTh5fZndI24VBD8lEkNUQPP1wWAOwEUQy-Yk1VTRg7L654ksf0jE4Obj_CDTPyIkK2f5C817--zE7uyngF3-hMRf3Taqus_jR2qqxYSz2D2B2nEYbrRWMDGoMf1tDHq3kFWaFqOr72IjgqkIDV3hs880mhiKcdI0USv54UK-tBon5B_WFJivPr5uo-OUrbILlU24AgTeLYskf1ajIIFnCqJVrAbYxEiaZ0cH1Ey5k6aDfRveb9wqhSQbTMGZuTsOw -e ClientSettings__Alias=docker-test -e ClientSettings__Trainer__CpuThreads=5  qliplatform/qubic-client:latest
```

## Linux Option 1: Screen Session  
To run the qubic.li client you can use this streamlined installation guide. Please consider adapt the commands to suit your directory preferences. Note that all commands must be executed as the root user, or you should precede them with the sudo command for proper authorization.  

> [!NOTE]
> With this method you do not have auto update

**1. Download and Unpack the qli-Client:**  
*Execute the following command to download and extract the qli-Client. This example uses the package qli-Client-3.3.7.1-Linux-x64.tar.gz. Please ensure you replace it with the latest available version.*  
```bash
mkdir ~/qubic;
cd ~/qubic;
wget https://dl.qubic.li/downloads/qli-Client-3.3.7.1-Linux-x64.tar.gz;
tar -xvf qli-Client-3.3.7.1-Linux-x64.tar.gz;
rm qli-Client-3.3.7.1-Linux-x64.tar.gz;
```  
**2. edit and set your appsettings.json according to your preferences**
```bash
nano appsettings.json
```
sample appsettings.json for GPU
```json
{
  "ClientSettings": {
    "accessToken": "YOURACCESSTOKEN",
    "alias": "YOURALIAS",
    "trainer": { "gpu": true, "gpuVersion": "CUDA" }
  }
}
```
> [!NOTE]
> Please refer to [QLI Trainer Options](#qli-trainer-options) for available `gpuVersion` values.

sample appsettings.json for CPU set to 10 threads:
```json
{
  "ClientSettings": {
    "accessToken": "YOURACCESSTOKEN",
    "amountOfThreads": 10,
    "alias": "YOURALIAS"
  }
}
```

**3. run qli-Client in a screen session named "qubic"**

```bash
screen -S qubic ./qli-Client
```
basic screen commands:  

- exit screen : `ctrl a + d`
- kill screen : `ctrl + c`
- display qubic screen: ``` screen -r qubic```  

## Linux Option 2 (expert): Systemd Linux Service
To install the qubic.li Service you can use our quick installation guide. Please consider to check the content of the service installation script.
All commands should either be executed by root or you need to prepend the `sudo` command.

The installerscript places all qubic.li stuff in `/q`.

> [!NOTE]
> WSL is by default not shipped with `systemd`. You may activate it with this help: https://learn.microsoft.com/de-de/windows/wsl/systemd


### Ubuntu 22.04
Don't forget to replace the token from the below examples with your own.

```bash
# update your sources
apt update
# download service installation script with autoupdate
wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken|payoutId> [alias]
./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g
```

for **ubuntu 20.04** you might need to install a more recent libc version.
```
# add repo (use a mirror near your location from: https://packages.ubuntu.com/jammy/amd64/libc6/download)
echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update
apt install libc6
apt install -y g++-11
```

### Debian 12
```bash
# download service installation script with autoupdate
# download service installation script
wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken|payoutId> [alias]
./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g
```
for **debian 11** you might need to install a more recent libc version.

### Service Monitoring
You can manage your qubic.li Client with the systemd control.

Start Service: `systemctl start qli`
Stop Service: `systemctl stop qli`
Status Service: `systemctl status qli`

you can also see what is going on by observing the logs.
the service logs to `/var/log/qli.log` or `/var/log/qli.error.log`.

to live watch it on the console, use `tail -f /var/log/qli.log`.


### sample minimal configuration with token
```json
{
	"Settings": {
        "trainer": {
            "cpuThreads": 16
        },
		"alias": "Client 3",
		"accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g"
	}
}
```
### sample minimal configuration with payout id
```json
{
	"Settings": {
		"trainer": {
            "cpuThreads": 16
        },
		"alias": "My super miner",
		"payoutId": "VGIWRRNVVRRXSEASPENCIMVNANPCFHAASZVPBIEFLCRYHWSZYSGXHNSBYPVN"
	}
}
```

## Remove Client
To remove the qubic.li Client execute the following commands.
```
# stop service
systemctl stop qli --no-block
# remove service definition
rm /etc/systemd/system/qli.service
# reload systemd
systemctl daemon-reload
# remove all related files
rm -R /q
rm /var/log/qli.log
```

## HiveOs
[HiveOs Instructions](https://github.com/qubic-li/hiveos)

## Customizing
The `appsettings.json` contains the configuration of your client and needs to be placed at the same location as the executable.

if you opt for the Linux Screen session (Option 1):
 - you can customize the settings of your client in the settings file `~/qubic/appsettings.json`

if you opt for the Systemd Linux Service (Option 2):
 - you can customize the settings of your client in the settings file `/q/appsettings.json`
 - You can create a custom file with the name `appsettings.production.json` which has higher priority to be loaded. (this file will not be overwritten when you install a new version manually)

|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  poolAddress 	|  `wss://wps.qubic.li/ws` 	|  The Pool Address 	|
|  accessToken* 	|  JWT Token 	| This is you personal JWT Token which you can obtain from the Control Panel at qubic.li 	|
|  qubicAddress* 	|  NULL 	| This is the ID you want to get token payout for your found solutions.	|
|  alias 	|  qli Client 	| You can give your Client a Name which will be displayed in the Control Panel. If empty it uses the Hostname.	|
|  pps	|  `true` 	| If the trainer should run in PPS mode  | 
|  autoUpdate	|  `false` 	| If the trainer should try to do an autoupdate  | 
|  trainer	|  {} 	| The [trainer configuration](#trainer-options) options  | 
|  idling	|  {} 	| The configuration options for the [Qubic idling](#idle-options) period | 
|  xmrSettings	|  {} 	| The configuration options for the [Qubic XMR POC](#xmr-options) period | 

### Trainer Options

```json
{
	"cpu": false,
	"cpuVersion": "AVX512",
	"cpuThreads": 16,
	"cpuAffinity": "",
	"cpuVariant": "",
	"gpu": true,
	"gpuVersion": "CUDA",
	"gpuCards": "",
	"gpuVariant": "",
    	"cpuName": null,
    	"gpuName": null,
	"downloadUrlRewrites": {
		"URLRegex": "anydomain.com"
	}
}
```


|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  cpu 	|  `true`	|  Enable CPU Training	|
|  gpu 	|  `true`	|  Enable GPU Training	|
|  cpuVersion 	|  `null`	|  null=AUTO = it tries to detect your CPU; CPU Version to be used [QLI Trainer Options](#qli-trainer-options)	|
|  gpuVersion 	|  `null`	|  null=AUTO = it tries to detect your GPU; GPU Version to be used [QLI Trainer Options](#qli-trainer-options)	|
|  cpuThreads 	|  `0`	|  Number of Threads used for CPU training	|
|  gpuCards 	|  `null`	|  Which GPU Cards should be used (see details below; available from client `>=1.9.5` and runner `>=105.3`)	|
|  cpuAffinity	|  `null`	|  CPU Affinity for CPU training	|
|  cpuVariant 	|  `null`	|  Which Variant of CPU trainer should be used	|
|  gpuVariant 	|  `null`	|  Which Variant of GPU trainer should be used	|
|  cpuName 	|  `null`	|  The specific name of the CPU trainer/worker.	|
|  gpuName 	|  `null`	|  The specific name of the GPU trainer/worker.	|
|  downloadUrlRewrites 	|  `null`	|  If you want to use your own download proxies for the trainer.	|

> [!NOTE]
> `"downloadUrlRewrites": { "dl\\.qubic\\.li": "anydomain.com" }`
> This example will rewrite the download url from `dl.qubic.li` to `anydomain.com`


> [!NOTE]
> The `gpuCards` property can be used to select `gThreads`. The default configuration is `auto tune` for all cards.<br>
> For each GPU you can use (comma separated):<br>
> `-1` => auto tune<br>
>  `0` => disable GPU<br>
> `>0` => number of `gThreads` to be used<br>
> >e.g.: `0,-1,-1,-1,-1,-1` => GPU#1 disabled, #1-5 auto tuen<br>
> e.g.: `0` => GPU#0 disabled, if there are more, all will be auto tuned<br>
> e.g.: `512,256,256,256,256,512` => set `gThread` to 512 on GPU#0 and GPU#5, 256 to the rest<br>

### Idle Options
During the Qubic idling phase. You can run another program or miner.

> [!WARNING]
> An idle program that changes settings or do not close properly when receiving SIGINT or be killed can harm the Qubic performance. Please only use this feature if you know what you do!


```json
{
    "preCommand": "ping",
    "preCommandArguments": "-c 2 google.com",
	"command": "ping",
	"arguments": "google.com",
    "postCommand": "ping",
    "postCommandArguments": "-c 2 google.com",
}
```

|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  command 	|  ""	|  the command/programm to execute	|
|  arguments 	|  ""	|  the arguments that should be given to the command/program	|
|  preCommand 	|  ""	|  a command/programm to start once the idling period starts	|
|  preCommandArguments 	|  ""	|  the arguments that should be given to the preCommand/program	|
|  postCommand 	|  ""	|  a command/programm to start once the idling period stopps	|
|  postCommandArguments 	|  ""	|  the arguments that should be given to the postCommand/program	|

### XMR Options
During the Qubic idling phase, the XMR POC is started automatically. You do not have to change anything at your current configuration.
We suggest to not add/change the below settings. They are here listed for reference only.

Please choose the QLI XMR Pool Adresses for optimal latency to your location:
|  Location 	|  Address 	|  Comments |
|---	|---	|---	|
|  Default  	|  stratum+tcp://xmr.qubic.li:3333 |  EU |
|  EU 	|  stratum+tcp://eu1.xmr.qubic.li:3333	|  Frankfurt |
|  HK 	|  stratum+tcp://hk1.xmr.qubic.li:3333	|  Hong Kong |
|  US 	|  stratum+tcp://us1.xmr.qubic.li:3333	|  New York |

```json
"xmrSettings": {
  "disable": false,
  "enableGpu": false,
  "poolAddress": "stratum+tcp://xmr.qubic.li:3333",
  "binaryName": null
}
```

|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  disable 	|  false	|  to disable the XMR module	|
|  enableGpu 	|  false	|  to enable GPU for XMR (not yet supported)	|
|  poolAddress 	|  "stratum+tcp://xmr.qubic.li:3333"	|  qubic xmr pool address (not a standrd XMR pool address)	|
|  binaryName 	|  "qli-worker-XMR"	|  the name of the xmr worker binary (default: qli-worker-XMR)	|
|  customParameters 	|  null	|  a string of parameters passed to xmrig (e.g. `-t 1` to run xmr instance with only one thread) All XMRig [Command Line Options](https://xmrig.com/docs/miner/command-line-options)	|

## Troubleshooting
The Client creates a folder `log` where all error messages are stored. If the Client stops unexpected or doesn't open check if there is a log file with current date and check the error messages.

### Authentication failed
If you see an error like this `ERROR   AUTHENTICATION FAILED`, you should create a new AccessToken. https://pool.qubic.li or check your internet connection.

### GPU and WSL doesn't work
The Community showed several solutions to that Problem. Please check the Qubic discord channel.

#### Install GPU drivers in Ubuntu
Try to install the Ubuntu nvidia drivers.

```bash
sudo apt update
sudo apt install nvidia-driver
sudo reboot
```

#### Disable Mining GPU for Windows
If you have a second GPU (e.g. from your processor) you can try to disable your mining GPU for windows and let windows use the second GPU to render your windows.

### AVX CPU (Intel) not working (legacy)
Somtimes the detection of AVX2/AVX512 is not accurate and it loads the wrong trainer.
If this happens to you, you can enforce certain configuration.

#### Enforce SKYLAKE
add `"cpuVersion": "SKYLAKE"` to trainer settings in appsettings.json

```json
{
	"ClientSettings": {
		"....": "...",
		"trainer": {
			"cpuVersion": "SKYLAKE"
		}
	}
}
```

#### Enforce AVX2
add `"cpuVersion": "AVX2"` to overwrites in appsettings.json

```json
{
	"ClientSettings": {
		"....": "...",
		"trainer": {
			"cpuVersion": "AVX2"
		}
	}
}
```

### Reset Configuration
if your trainer isn't working properly. try the following to reset local configuration:
```
# stop trainer
systemctl stop qli --no-block
# ensure that all qli services are stopped/killed
pkill -f qli
# delete any existing configuration lock
rm /q/*.lock
# delete current runner
rm /q/qli-worker*
# start trainer
systemctl start qli --no-block
```

### Reset Server
if you think the client reports wrong or random hashrate you could restart your server. Or stop all qli services. (e.g. for linux: `systemctl stop qli --no-block && pkill -f qli && systemctl start qli`)

### Possible Optimizations
Every specific CPU or general Hardware configuration can need speific performance settings. Depending on your Setup you can try:

1. Enable/Disable SMT/HT in Bios
2. Enabled/Disable Performance Boost (Windows)
3. Enable/Disable specific Power Schema (Ubuntu)
4. Adjust Threads to your needs. Sometimes less threads is more effective thatn to many.
