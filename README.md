# qubic.li - Client
This is the main client component from qubic.li. It connects to the backend api and receives tasks to perform.

The Client runs on Docker, Windows and Linux. Below you find the instructions how to use it.

1. [Security Warning](#security-warning)
2. [Download](#download)
3. [What's needed](#whats-needed)
4. [Using Docker](#using-docker)
5. [Windows](#windows)
6. [Linux Service Installatin](#linux-service)
   1. [Ubuntu 22.04](#ubuntu-2204)
   2. [Debian 11](#debian-11)
   3. [Monitoring](#service-monitoring)
   4. [Service Customizing](#customizing)


## Security Warning
The client is able to download runners, which then performs the AI Training tasks. This can potentially be used in a bad manner. Run the client with the least priviliges which are possble. e.g. on windows NOT as Admininstrator; on linux NOT as root.

Find more information about the "principle of least privilege" on wikipedia: https://en.wikipedia.org/wiki/Principle_of_least_privilege

## Download

| OS |  Platform 	|  Version 	|  Download |
|--- |---	|---	|---	|
| Windows | x64	| 1.1.11	| https://qubic.li/downloads/qli-Client-1.1.11-Windows-x64.zip	|
| Linux | x64	| 1.1.11	| https://qubic.li/downloads/qli-Client-1.1.11-Linux-x64.tar	|

## What's needed
To run the qubic.li Client you need .Net Runtime in Version 6 on all platforms. You can get it from: https://dotnet.microsoft.com/en-us/download/dotnet/6.0.

The runner needs also the VC Redistributable which can be obtained from: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170

## Windows
You can run the client directly in your Windows. The Client provices a .exe file which can be executed by a double click.

Download the Client from the above link. The Client must not be installed.


## Using Docker
You can use Docker to run the qubic.li Client. Use the official Docker Image from: https://hub.docker.com/r/j0et0m/qubicliclient

Don't forget to set the correct Environment Settings.

|  Env 	|  Default Value 	|  Description 	|
|---	|---	|---	|
| Settings__accessToken	| qubic.li Token	| This is you personal JWT Token which you can obtain from the Control Panel at qubic.li	|
| Settings__amountOfThreads	| 1	| How many threads should be used for the AI Training.	|
| Settings__alias	| qubic.li Docker	| You can give your Client a Name which will be displayed in the Control Panel. If empty it uses the Hostname.	|


## Linux Service
To install the qubic.li Service you can use our quick installation guide. Please consider to check the content of the service installation script.
All commands should either be executed by root or you need to prepend the `sudo` command.

The installerscript places all qubic.li stuff in `/q`.


### Ubuntu 22.04
If the below installation of dotnet6 is not working on your ubuntu please consider to install it directly from microsoft: https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-2204

```bash
# Update packages
apt update
# Install .Net 6
apt install dotnet6 -y
# download service installation script
rm qli-Service-install.sh || wget https://qubic.li/cloud-init/qli-Service-install.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken> [alias]
./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjVlNjJhZjhjLWU5ZTgtNDBiMS04ZmMyLTM5Mzg0Mzk5OTcwNyIsIk1pbmluZyI6IiIsIm5iZiI6MTY3MjE3MTIwMywiZXhwIjoxNzAzNzA3MjAzLCJpYXQiOjE2NzIxNzEyMDMsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.DJkHv_2K0eNiAkjKia8bxag5I4ixOtjk36AGE6zwzxiEFO_w8ovsoLY4ARONUwnak_N-5-W69PJbbKCphyICpQ
# remove service install script
rm qli-Service-install.sh
```


### Debian 11
```bash
# download and install microsoft sourcese for dotnet installation
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
# Update Sources and install .Net 6 package
apt update && apt install aspnetcore-runtime-6.0 -y
# download service installation script
rm qli-Service-install.sh || wget https://qubic.li/cloud-init/qli-Service-install.sh
# set the script as executable
chmod u+x qli-Service-install.sh
# install qubic.li client as systemd service
# Syntax: qli-Service-install.sh <threads> <accessToken> [alias]
./qli-Service-install.sh 2 eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjVlNjJhZjhjLWU5ZTgtNDBiMS04ZmMyLTM5Mzg0Mzk5OTcwNyIsIk1pbmluZyI6IiIsIm5iZiI6MTY3MjE3MTIwMywiZXhwIjoxNzAzNzA3MjAzLCJpYXQiOjE2NzIxNzEyMDMsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.DJkHv_2K0eNiAkjKia8bxag5I4ixOtjk36AGE6zwzxiEFO_w8ovsoLY4ARONUwnak_N-5-W69PJbbKCphyICpQ
# remove service install script
rm qli-Service-install.sh
```

### Service Monitoring
You can manage your qubic.li Client with the systemd control.

Start Service: `systemctl start qli`
Stop Service: `systemctl stop qli`
Status Service: `systemctl status qli`

you can also see what is going on by observing the logs.
the service logs to `/var/log/qli.log` or `/var/log/qli.error.log`.

to live watch it on the console, use `tail -f /var/log/qli.log`.


### Customizing
you can customize the settings of your client in the settings file `/q/appsettings.json`

This file contains the configuration of your client and need to be placed at the same location as the executable.
You can create a custom file with the name `appsettings.production.json` which has higher priority to be loaded.

|  Setting 	|  Default Value 	|  Description 	|
|---	|---	|---	|
|  baseUrl 	|  https://mine.qubic.li/ 	|  The Base Url of the API 	|
|  amountOfThreads 	|  1 	|  How many threads should be used for the AI Training.	|
|  accessToken 	|  JWT Token 	| This is you personal JWT Token which you can obtain from the Control Panel at qubic.li 	|
|  alias 	|  qli Client 	| You can give your Client a Name which will be displayed in the Control Panel. If empty it uses the Hostname.	|




