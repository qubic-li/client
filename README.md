# qubic.li - Client
This is the main client component from qubic.li. It connects to the backend api and receives tasks to perform.

The Client runs on Docker, Windows and Linux. Below you find the instructions how to use it.

1. [Security Warning](#security-warning)
2. [Pool Mining](#pool-mining)
3. [Download](#download)
4. [What's needed](#whats-needed)
5. [Windows](#windows)
7. [Linux Option 1: Run qli-Client in a Linux Screen](#linux-option-1-screen-session)
6. [Linux option 2: Run qli-Client as Linux Service (Expert)](#linux-option-2-expert-systemd-linux-service)
   1. [Ubuntu 22.04](#ubuntu-2204)
   2. [Debian 12](#debian-12)
   3. [Redhat Enterprise 8.8](#redhat-enterprise-88)
   4. [Monitoring](#service-monitoring)
   5. [Remove Client](#remove-client) 
7  [Appsettings.json Customization](#customizing)
8. [Hive OS/Rave Os](https://github.com/qubic-li/client/releases/tag/v1.8.8/release_notes.md)
9. [Troubleshooting](#troubleshooting)

## Security Warning
The client is able to download runners, which then performs the AI Training tasks. This can potentially be used in a bad manner. Run the client with the least priviliges which are possble. e.g. on windows NOT as Admininstrator; on linux NOT as root.

Find more information about the "principle of least privilege" on wikipedia: https://en.wikipedia.org/wiki/Principle_of_least_privilege

## Pool Mining
If you don't want to operate your own Qubic infrastructure. You can join the qubic.li pool mining. You can either register an account (highly recomended) on http://app.qubic.li or you can join pool mining register-less.

If you want to create your own account, follow the instructions here: https://doc.qubic.world/becoming-a-computor-miner/how-to-participate

If you want regitration-less pool mining, do the following:
1. Create a Qubic Id (e.g. on https://wallet.qubic.li)
2. Download Client from below (Version >=1.2)
3. Start your Client with `qli-Client <QUBICID> <THREADS>`
4. Check your performance: https://app.qubic.li/public

You can also put your PayoutId into the [configuration file](#customizing) if you don't want to use command line arguments.

## Download
We recommend to update your Version if there is a change in the Minor Version (e.g. from 1.3 to 1.4).
Bugfix releases (e.g. from 1.3.1 to 1.3.2) are optional.

| OS |  Platform 	|  Version 	|  Download | Description
|--- |---	|---	|---	|--- |
| Windows | x64	| 1.8.7 | https://dl.qubic.li/downloads/qli-Client-1.8.7.1-Windows-x64.zip	|
| Windows | x64	| 1.8.8 (beta) | https://dl.qubic.li/downloads/qli-Client-1.8.8-Windows-x64.zip	|
| Windows | x64	| 1.8.7 | https://dl.qubic.li/downloads/qli-Client-1.8.7.1-Windows-x64-Plain.zip	| Version without default configuration
| Linux | x64	| 1.8.7 | https://dl.qubic.li/downloads/qli-Client-1.8.7.1-Linux-x64.tar.gz	| 
| Linux | x64	| 1.8.8 (beta) | https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz	| 
| Hive Os | x64	| 1.8.8 (beta) | https://github.com/qubic-li/client/releases/download/v1.8.8/eloword-v1.8.8.tar.gz	| Hiveos custom flightsheet
| Rave Os | x64	| 1.8.8 (beta) | https://github.com/qubic-li/client/releases/download/v1.8.8/raveoscustom-eloword-1.8.8.zip	| Raveos custom package


## What's needed
The runner on windows needs also the VC Redistributable which can be obtained from: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170

The runner on linux needs at least **GLIBC 2.34**.

The CPU where you run the Client **must** support `AVX2` or `AVX512` CPU instructions.

## Command Line Arguments vs. Configuration
You can either start the Client by providing command line arguments or using an [appsettings.json](#customizing) file.

|  Argument 	|  Default Value 	|  Description 	|
|---	|---	|---	|
| PayoutId	| NULL	| The Qubic ID you want to receive the mining payouts if you participate in pool mining	|
| Threads	| 1	| How many threads should be used for the AI Training.	|
| Alias	| qubic.li Client	| You can give your Client a Name which will be displayed in the |

## Windows
You can run the client directly in your Windows. The Client provices a .exe file which can be executed by a double click.

Download the Client from the above link. The Client must not be installed.

## Linux Option 1: Screen Session  
To run the qubic.li client you can use this streamlined installation guide. Please consider adapt the commands to suit your directory preferences. Note that all commands must be executed as the root user, or you should precede them with the sudo command for proper authorization.  

**1. Download and Unpack the qli-Client:**  
*Execute the following command to download and extract the qli-Client. This example uses the package qli-Client-1.8.8-Linux-x64.tar.gz. Please ensure you replace it with the latest available version.*  
```bash
mkdir ~/qubic;
cd ~/qubic;
wget https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz;
tar -xvf qli-Client-1.8.8-Linux-x64.tar.gz;
rm qli-Client-1.8.8-Linux-x64.tar.gz;
```  
**2. edit and set your appsettings.json according to your preferences**
```bash
nano appsetings.json
```
sample appsettings.json for GPU:
```json
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "allowHwInfoCollect": true,
    "overwrites": {
      "CUDA": "12"
    },
    "accessToken": "YOURACCESSTOKEN",
    "alias": "YOURALIAS"
  }
}
```
sample appsettings.json for CPU set to 10 threads:
```json
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "overwrites": {},
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

- exit screen : ctrl a + d  
- kill screen : ctrl + c  
- display qubic screen: ``` screen -r qubic```  

## Linux Option 2 (expert): Systemd Linux Service
To install the qubic.li Service you can use our quick installation guide. Please consider to check the content of the service installation script.
All commands should either be executed by root or you need to prepend the `sudo` command.

The installerscript places all qubic.li stuff in `/q`.


### Ubuntu 22.04
Don't forget to replace the token from the below examples with your own.

```bash
# update your sources
apt update
# download service installation script with autoupdate
# wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# download service installation script without auto update
wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install.sh
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
# wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# download service installation script
wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken|payoutId> [alias]
./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g
```
for **debian 11** you might need to install a more recent libc version.

### Redhat Enterprise 8.8
> DEPRECATED
```bash
# Update packages
sudo yum update
# download service installation script with autoupdate
# wget -O qli-Service-install.sh https://dl.qubic.li/cloud-init/qli-Service-install-auto.sh
# download service installation script
rm qli-Service-install.sh || wget https://dl.qubic.li/cloud-init/qli-Service-install.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken|payoutId> [alias]
sudo ./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g
```

### Service Monitoring
You can manage your qubic.li Client with the systemd control.

Start Service: `systemctl start qli`
Stop Service: `systemctl stop qli`
Status Service: `systemctl status qli`

you can also see what is going on by observing the logs.
the service logs to `/var/log/qli.log` or `/var/log/qli.error.log`.

to live watch it on the console, use `tail -f /var/log/qli.log`.


### sample configuration with token
```json
{
	"Settings": {
		"baseUrl": "https://mine.qubic.li/",
		"amountOfThreads": 16,
		"alias": "Client 3",
		"accessToken": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImMyYmUyNTVkLWRkNzAtNDE4Mi04MDdkLWM1M2M5Yjc5ZDgyNiIsIk1pbmluZyI6IiIsIm5iZiI6MTcwNDczODc4NSwiZXhwIjoxNzM2Mjc0Nzg1LCJpYXQiOjE3MDQ3Mzg3ODUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.j8oI56OqV-gjoHxacwegetd2nha1zHLfSjW-REcNsp8q0lWW-NbvClPIuy_nig-YqpbyPXRPAZvYjh1SUjkw7g"
	}
}
```
### sample configuration with payout id
```json
{
	"Settings": {
		"baseUrl": "https://mine.qubic.li/",
		"amountOfThreads": 16,
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

## Customizing

Appsettings.json contains the configuration of your client and need to be placed at the same location as the executable.

if you opt for the Linux Screen session (Option 1):
 - you can customize the settings of your client in the settings file ` ~/qubic/appsettings.json`

if you opt for the Systemd Linux Service (Option 2):
 - you can customize the settings of your client in the settings file `/q/appsettings.json`
 - You can create a custom file with the name `appsettings.production.json` which has higher priority to be loaded.

|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  baseUrl 	|  https://mine.qubic.li/ 	|  The Base Url of the API 	|
|  amountOfThreads 	|  1 	|  How many threads should be used for the AI Training.	|
|  accessToken* 	|  JWT Token 	| This is you personal JWT Token which you can obtain from the Control Panel at qubic.li 	|
|  payoutId* 	|  NULL 	| This is the ID you want to get token payout for your found solutions.	|
|  alias 	|  qli Client 	| You can give your Client a Name which will be displayed in the Control Panel. If empty it uses the Hostname.	|
|  useAvx2 	|  false 	| !DEPRECATED! Set this to `true` to force the Client to use only AVX2	|
|  allowHwInfoCollect	|  false 	| With that option set to `true` the client will collect CPU model, CPU Cache Size and RAM Size to get optimal runner for that maschine	|
|  threadsDaySchedule 	|  empty 	| Can be used to schedule the training. e.g. training should only run during night time. |
|  customRunner	|  false 	| Set this to `true`  to use a custom trainer. The Client will not automatically update runner. [Details](CustomRunner.md) | 
|  serviceLock	|  false 	| Set this to `true`  to use a custom trainer with qiner protocol. | 
|  overwrites	|  {} 	| An object to overwrite specific settings. (e.g. `"AVX512":false` to disable AVX512) | 
|  autoupdateEnabled	|  false 	| Set this to `true` to enable auto update of the service client (from version 1.7.8) | 
|  checkUpdateEnabled	|  true 	| Checks if there is a new version of the service client when starting | 


*Only one of these can be defined.


## Troubleshooting
The Client creates a folder `log` where all error messages are stored. If the Client stops unexpected or doesn't open check if there is a log file with current date and check the error messages.

### AVX CPU (Intel) not working
Somtimes the detection of AVX2/AVX512 is not accurate and it loads the wrong trainer.
If this happens to you, you can enforce certain configuration.

#### Enforce SKYLAKE
add `"SKYLAKE": true` to overwrites in appsettings.json

```json
{
	"Settings": {
		"....": "..."
		"overwrites": {
			"SKYLAKE": true
		}
	}
}
```

#### Enforce AVX2
add `"AVX512": false` to overwrites in appsettings.json

```json
{
	"Settings": {
		"....": "..."
		"overwrites": {
			"AVX512": false
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
rm /q/qli-runner
# delete old solutions
find /q/. -maxdepth 1 -regextype posix-extended -regex '.*\.e[[:digit:]]+' -delete
# delete state files
find /q/. -maxdepth 1 -regextype posix-extended -regex 'state\.[[:digit:]]+' -delete
# start trainer
systemctl start qli --no-block
```

### Reset Server
if you think the client reports wrong or random hashrate you could restart your server. Or stop all qli services. (e.g. for linux: `systemctl stop qli --no-block && pkill -f qli && systemctl start qli`)

### Possible Optimizations
Every specific CPU or general Hardware configuration can need speific performance settings. Depending on your Setup you can try:

1. Enable/Disable SMT/HT in Bios
2. Choose another runner via Webinterface: https://app.qubic.li/main/mining/control
3. Enabled/Disable Performance Boost (Windows)
4. Enable/Disable specific Power Schema (Ubuntu)
5. Add/Remove `wine` in linux. (for ubuntu: `apt install wine -y` or `apt autoremove wine -y`
6. Adjust Threads to your needs. Sometimes less threads is more effective thatn to many.
