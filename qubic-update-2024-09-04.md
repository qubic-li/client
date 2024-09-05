# Qubic idling - What to do?

On 2024-09-04 Qubic had a breaking change in their AI Training mechanics.

Before, the trainers were active 24h. Like in the most other projects.
Now, Qubic has introduces phases.

1. Training
2. Idling

Both phases are not directly determined by time, more, they have a specific lenght in term of amount of ticks.
The traditional training phase runs `676 + 3` Ticks. The idling phase runs `676` ticks. In time this is with the current setup per phase ~30-60 minutes.

To support this new mechanics we build a new infrastructure to optimize handling of this process.

## Environment Comparison

|  Environment 	|  Dashboard 	|  Pool Address (baseUrl)  | Socket Address	|   max delay	| PPS Support |
|---	|---	|---	|--- |--- |---	|
|  classic 	|  https://app.qubic.li 	|   https://mine.qubic.li 	| - |  30 seconds 	| - |
|   modern	|  https://pool.qubic.li 	|  https://wps.qubic.li 	| wss://wps.qubic.li:443 |   <1 second	| yes |

## Transition
The transition from classic > modern is up to you. You can choose the moment in which you want to switch.
The live stats of both platforms are not directly connected. But, if you switch to modern without PPS, you will still see your solutions in classic.

## Quick way
1. Create a new `AccessToken`: https://pool.qubic.li
2. Add `"useLiveConnection":true` to your settings.

The quickest way to switch your client from classic to modern is by adding `"useLiveConnection":true` to your settings. (`appsettings.json` or `hive os extra config`)
By adding the `useLiveConnection` the client will automatically choose the websocket connection to `wps.qubic.li`. If there is a connection problem. The Client will fall back to non websocket connection.

sample configuration
```
{
	"Settings": {
      "baseUrl": "https://mine.qubic.li/",
      "useLiveConnection": true,
      "amountOfThreads": 16,
      "alias": "My super miner",
      "accessToken": "YOURTOKEN"
	}
}
```
> ATTENTION
> If you use `wps.qubic.li` as baseUrl, the client will automatically fall into `PPS` mode. You can disable this by adding `"isPps":false` to your settings.

You can check also all [Options](https://github.com/qubic-li/client/?tab=readme-ov-file#customizing).

## Can i go back?
Yes, by removing the `useLiveConnection`, your client will go back to classic mode.

## Why idling?
You can safe electricity by having the same revenue. Or you can use the idling time to do something productive. The [Idling Options](https://github.com/qubic-li/client/?tab=readme-ov-file#idle-options) describe how you can configure it.

Qubic uses the current idling scheme do experiment with outsourcing computing power. As long this is not enforced by Qubic, you are free to run every program.

