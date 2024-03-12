![1](https://github.com/EloWord/raveos/assets/155255722/2d6863b9-edaf-4700-9c19-decb92dfe480)


Version 1.8.8

- added ability to resend unsubmitted solution after a client restart
- Removed HugePages settings from RaveOs
- Fixed path issue in raveos package
- Other stability fixes


### RaveOs full Qubic and Eloword Miner Integration

🚀   No need for custom package additions anymore
Qubic and Eloword are now successfully integrated into Rave OS. This seamless integration enhances the Qubic mining experience and offers an efficient and user-friendly solution .

1.8.8 custom package available: https://github.com/qubic-li/client/releases/download/v1.8.8/raveoscustom-eloword-1.8.8.zip

Packages are now uploaded in [Qubic-li official repository](https://github.com/qubic-li/client/releases)


![3](https://github.com/EloWord/raveos/assets/155255722/d72ecac5-d158-4d03-9609-157d235a6503)



<br>

## :star2: Support My Work and Contribute to its Growth :star2:

If you appreciate my work and want to contribute to its ongoing development, consider leaving a tip. Every contribution, big or small, makes a huge difference and motivates me to continue creating and improving.

- **To support me, use Qubic:** `TWVQTVPLEMNCWBJZFVCLCZCDGBDBLBWBAPCVQJOUECEZQQBMAPAXSRBEABSK`

*Support received since this version: 620,240,488 Qubic - Thank you for your future support!*

[<img src="https://github.com/EloWord/hiveos/assets/155255722/dedb996d-c517-4059-a55a-d9adea9a21f1" alt="discord" width="200">](https://discord.gg/bWHcuuyQBf)

Thank you for being part of this journey!
<br>

## :warning: Mandatory Installation Instructions (12/03/2024)
- The CPU where you run the Client must support AVX2 or AVX512 CPU instructions
`cat /proc/cpuinfo | grep avx2`(check if `avx2` is in the result)
- Drivers 535+: run this command to upgrade RaveOs ```upgrade 8926-2226```
- Use recommended OC **before** mining
- RAM >= 16Go improves CPU it/s
- Do not overload your CPUs with threads, instead, aim to find the sweetpoint

*Only NVIDIA GPU compatible*
<br>

## :wrench: Settings

- it's an all-in-one miner (CPU+GPU / GPU only), check out settings below for seamless setup

- Recommended Rave OS GPU overclocks :
**Medium**
3000 series ```nvidia-smi -lmc 7000 && nvidia-smi -lgc 1500```
4000 series ```nvidia-smi -lmc 7000 && nvidia-smi -lgc 2400```
**High**
3000 series ```nvidia-smi -lmc 7000 && nvidia-smi -lgc 1700```
4000 series ```nvidia-smi -lmc 7000 && nvidia-smi -lgc 2900```

Please use "Tunning Settings" from workers's dashboard to set global or specific OC like this:
<img src="https://github.com/EloWord/raveos/assets/155255722/5ac7b358-02c0-43fe-9531-3e8fe768bc3b" width="30%">


<br>

- Additional Command Line Arguments (options):

| Setting | Description |
| ---- | --------- |
| ```"accessToken":``` | This is you personal JWT Token which you can obtain from the Control Panel at qubic.li |
| ```"payoutId":``` |  This is the ID you want to get token payout for your found solutions. |
|  ```"overwrites": {"AVX512": false}``` |  Disable AVX512 and enforce AVX2 (AVX Intel CPU not working) |
| ```"overwrites": {"SKYLAKE": true}```  |  Enforce SKYLAKE (AVX Intel CPU not working)  |
<br>

## ✈️ Rave OS Settings


#### I/ Add Wallet: Select Qubic and Eloword in the lists

![4](https://github.com/EloWord/raveos/assets/155255722/4c486184-e546-4491-9b26-4b0f352745be)


#### II/ Set Miner Param
- *** GPU + CPU Mining ***

```
"amountOfThreads":12
"accessToken":"YOUROWNTOKEN"
```
![Capture d’écran 2024-03-03 à 20 43 40](https://github.com/EloWord/raveos/assets/155255722/deab08e2-58ef-43da-b71b-42093e3da154) 

- *** GPU Only Mining ***

```
"accessToken":"YOUROWNTOKEN"
```
![Capture d’écran 2024-03-03 à 20 43 21](https://github.com/EloWord/raveos/assets/155255722/7a60c27d-a750-4417-b2e0-91d12dcb1a42)

#### III/ Run Miner

![2](https://github.com/EloWord/raveos/assets/155255722/c702c5e3-dca3-4805-8bc8-a6cdfd5574f5)
