# QLI Farm Connect
QLI Farm Connect is a specific proxy to connect to the QLI platform.
This allows anyone to operate its own entry point (API) for the [QLI Client](https://github.com/qubic-li/client).

>[!Important]
>Farm Connect is in beta state and may run with errors.

1. [Account is needed](#account-is-needed)
2. [Quick Test (not recommended)](#quick-test-not-recommended)
3. [Docker Compose (recommended)](#docker-compose-recommended)
4. [Docker Environment Variables](#docker-environment-variables)
5. [Farm Connect API](#farm-connect-api)
6. [When to use Farm Connect](#when-to-use-farm-connect)
7. [How to connect Clients to Farm Connect](#how-to-connect-clients-to-farm-connect)

![QLI-FarmConnect](https://github.com/user-attachments/assets/7f124085-dacb-4203-af5e-f1c9f06f9592)

## Account is needed
To operate with Farm Connect, you need a valid account on the QLI Platform. You can register an account on https://pool.qubic.li.
Farm Connect is compatible with standard pool and self hosted training. Currently it only works in **solo** mode.

## Quick Test (not recommended)
If you want to see how it works the quick way, start the following command.

```bash
docker run --name qli-farm-connect   -e FarmConnect__AccessToken=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImUxODc5YzQ3LTIwZjUtNDA5Yy05MThkLTRhYzgyNzFiYjYxMSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNTE5NzA5NSwiZXhwIjoxNzU2NzMzMDk1LCJpYXQiOjE3MjUxOTcwOTUsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.hBYWpMvvpj8N-t6r6iIdF5y8ayKxtSi0FEb689oOrbPiwBrs76MBvpva7mbOQslzuEFJ8jZSFHlD1QgR6P9YMcTh5fZndI24VBD8lEkNUQPP1wWAOwEUQy-Yk1VTRg7L654ksf0jE4Obj_CDTPyIkK2f5C817--zE7uyngF3-hMRf3Taqus_jR2qqxYSz2D2B2nEYbrRWMDGoMf1tDHq3kFWaFqOr72IjgqkIDV3hs880mhiKcdI0USv54UK-tBon5B_WFJivPr5uo-OUrbILlU24AgTeLYskf1ajIIFnCqJVrAbYxEiaZ0cH1Ey5k6aDfRveb9wqhSQbTMGZuTsOw   -e FarmConnect__Name=test-container1 -v /root/data:/app/data qliplatform/farm-connect:latest
```

## Docker Compose (recommended)

### Create a docker compose file
e.g. `touch compose.yaml`

Add the following content:
```yaml
services:
  qli-farm-connect:
    image: qliplatform/farm-connect:latest
    restart: always
    container_name: qli-farm-connect
    ports:
      - "80:8080" # opens port 80 for communication
    # Optional to save local cache data outside of the container
    # volumes:
    #  - /root/data:/app/data
    environment:
      FarmConnect__Name: "My Farm XY" # the name of your farm
      FarmConnect__AccessToken: "ACCESSTOKEN" # your qli platform access token
      FarmConnect__ApiPassword: "MySuperSecretPassword" # CHANGE! this to a secret password used to access the farm connect API

  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 300
```

The above `compose.yaml` file will start Farm Connect and also add the [Watchtower](https://github.com/containrrr/watchtower) which will keep your Farm Connect always up to date. With `--interval 300` every 5 minutes Watchtower will check for a new Farm Connect version and if there is one, update it automatically.

### Start Docker Compose
```bash
docker compose up -d
```

### Stop Docker Compose
```bash
docker compose down
```

### Monitor Output
Latest Log Messages: 
```bash
docker logs qli-farm-connect
```


Follow Log Messages:
```bash
docker logs -f qli-farm-connect`
# (Cancel with CTRL+C)
```

## Docker Environment Variables


| Param    | Default | Description |
| -------- | ------- | ---- |
| **FarmConnect_AccessToken | empty | Your QLI Platform AccessToken |
| *FarmConnect__Name  | `QLI Farm Connect`    | The Name of your Farm |
| *FarmConnect_ApiPassword    | random value | The password needed to access the Farm Connect API |
| FarmConnect__DataFolder  | `data`    | The Name of your Farm |
| FarmConnect__TargetSeedBufferSize | `1`    | The max number of target Seeds that should be trained at the same time |
| FarmConnect__PoolAddress | `wps.qubic.li`    | Main pool address |

**Required<br>
*Recommended to set

## Farm Connect API
The QLI Farm Connect offers an API to query current performance data.

To access the API, you need to provide for each request the defined password as an URL parameter.

### Status Endpoints

| Method    | Endpoint | Description |
| -------- | ------- | ---- |
| GET    | `/status/RandomMiningSeed?pw=<APIPassword>` | Returns the current active mining seed |
| GET    | `/status/LiveStat?pw=<APIPassword>` | Returns live stats of connected clients |
| GET    | `/status/CalculatedStat?pw=<APIPassword>` | Returns calculated/verified stats of your account (e.g. found solutions) |

### Command Endpoints
| Method    | Endpoint | Description |
| -------- | ------- | ---- |
| GET    | `/command/ReloadTargetSeeds?pw=<APIPassword>` | Let's Farm Connect refetch current target seeds | 

### Sample Request
Scheme: `http://<YOURIP/YOURDOMAIN>:<YOURPORT>/status/LiveStat?pw=<YOURAPIPASSWORD>`

Sample: `http://10.10.10.10:80/status/LiveStat?pw=suhc.ksdfdsf`

## When to use Farm Connect
Using Farm Connect can have a possitive effect for you when:

- When you want to connect **>100** clients from same location
- When your internet bandwidth is limited
- When you do not want to use official QLI pool addresses
- When you want to do custom statitstics
- When you want to have custom monitoring of your clients

### Use Case: Limited Bandwidth
Assuming you run an own training farm with 100erds of clients and you have only one internet access. This could also harm your clients performance.

Farm Connect as proxy between the QLI API and your clients helps to reduce needed bandwith. Your clients will connect to Farm Connect instead of the official QLI API.

## How to connect Clients to Farm Connect
To connect your clients to Farm Connect, just change the `baseUrl`, `socketUrl` and/or `poolAddress` to your own IP Address/Domain.

Sample Configuration for Clients with Version `< 3.0`
```json
...
"baseUrl": "http://YOURIPADDRESS:YOURPORT",
"socketUrl": "ws://YOURIPADDRRESS:YOURPORT/ws"
...
```

Sample Configuration for Clients with Version `>= 3.0`
```json
...
// scheme
"poolAddress": "ws://YOURIPADDRESS:YOURPORT/"

// example with ip address and default port 80
"poolAddress": "ws://10.10.10.10/ws"
// example with ip address and custom port 3548
"poolAddress": "ws://10.10.10.10:3548/ws"

// example with domain and default port 80
"poolAddress": "ws://myFarmConnect.com/ws"
// example with domain and custom port 3548
"poolAddress": "ws://myFarmConnect.com:3548/ws"

// example with domain and SSL proxy and default port 443
"poolAddress": "wss://myFarmConnect.com/ws"
// example with domain and SSL proxy and custom port 3548
"poolAddress": "wss://myFarmConnect.com:3548/ws"
...
```
