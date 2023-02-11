# A simple script for testing network performance with speedtest-cli
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fnetwork-speed.xyz&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com)

Just a simple script for testing network performance.

Shows the following info:
   - Basic System Info - like CPU, RAM, Disk etc
   - Basic Network Info - Protocol (IPv4/v6), ISP, Location etc
   - Ookla speedtest.net to servers around the world with speed, ping, packet loss etc
   - Statistics from the speedtest


Thanks to Teddysun <i@teddysun.com> for the base bench.sh script

## Usage
```
curl -sL network-speed.xyz | bash
```
```
wget -qO- network-speed.xyz | bash
```

## Sample Output
```
---------------------------- network-speed.xyz ----------------------------
      A simple script to test network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : 11/02/2023
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD Ryzen 9 3950X 16-Core Processor
 CPU Cores          : 3 @ 3499.998 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 98.1 GB (5.1 GB Used)
 Total RAM          : 4.8 GB (200.2 MB Used)
 System uptime      : 41 days, 22 hour 18 min
 Load average       : 0.00, 0.00, 0.00
 OS                 : Ubuntu 20.04.4 LTS
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.4.0-135-generic
 Virtualization     : KVM
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv4
 ISP                : Alibaba.com LLC
 ASN                : AS3214 xTom GmbH
 Host               : Zenlayer Inc, Virtual Machine Solutions LLC
 Location           : Amsterdam, North Holland (NH)
 Country            : Netherlands
---------------------------------------------------------------------------
 Speedtest.net
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: xTom GmbH

 Nearest          1.02 ms     0.0%    929.25 Mbps    1842.92 Mbps   Vancis - Amsterdam

 Cochin, IN       166.44 ms   N/A     582.82 Mbps    561.06 Mbps    Jio - Kochi
 Bangalore, IN    177.40 ms   0.0%    464.53 Mbps    386.81 Mbps    Bharti Airtel Ltd - Bangalore
 Chennai, IN      141.73 ms   N/A     591.32 Mbps    364.27 Mbps    Jio - Chennai
 Mumbai, IN       125.87 ms   0.0%    1011.82 Mbps   661.08 Mbps    i3D.net - Mumbai
 Delhi, IN        166.89 ms   0.0%    648.98 Mbps    516.07 Mbps    Tata Play Fiber - New Delhi

 Los Angeles, US  150.55 ms   0.0%    666.92 Mbps    194.78 Mbps    DediPath - Los Angeles, CA
 Dallas, US       110.04 ms   0.0%    1325.52 Mbps   650.41 Mbps    Hivelocity - Dallas, TX
 New York, US     83.17 ms    0.0%    1037.69 Mbps   1095.90 Mbps   Clouvider Ltd - New York, NY
 Seattle, US      154.82 ms   N/A     825.87 Mbps    576.29 Mbps    Comcast - Seattle, WA
 Miami, US        116.16 ms   0.0%    1039.51 Mbps   643.69 Mbps    AT&T - Miami, FL
 Montreal, CA     112.49 ms   0.0%    988.43 Mbps    767.76 Mbps    Rogers Wireless - Montréal, QC

 Paris, FR        16.59 ms    0.0%    1787.98 Mbps   1793.63 Mbps   ORANGE FRANCE - Paris
 Amsterdam, NL    0.58 ms     0.0%    935.93 Mbps    937.20 Mbps    Hivelocity - Amsterdam
 Warsaw, PL       22.77 ms    0.0%    1555.61 Mbps   1752.61 Mbps   UPC Polska - Warszawa
 London, UK       6.20 ms     0.0%    1861.99 Mbps   926.44 Mbps    VeloxServ Communications - London
 Frankfurt, DE    7.70 ms     0.0%    1802.82 Mbps   1814.85 Mbps   Deutsche Telekom - Frankfurt Am Main

 Dubai, AE        122.11 ms   0.0%    1396.82 Mbps   707.12 Mbps    du - Dubai
 Fujairah, AE     118.07 ms   0.0%    717.25 Mbps    746.54 Mbps    i3D.net - Dubai
 Jeddah, KSA      69.51 ms    0.0%    1566.19 Mbps   1232.92 Mbps   Saudi Telecom Company

 Shanghai, CN     189.58 ms   0.0%    632.39 Mbps    220.04 Mbps    China Unicom 5G - ShangHai
 Guangzhou, CN    253.15 ms   7.7%    58.26 Mbps     16.12 Mbps     ChinaTelecom 5G - Guangzhou
 Hong Kong, SAR   242.24 ms   N/A     363.11 Mbps    354.92 Mbps    STC - Hong Kong
 Singapore, SG    156.32 ms   0.0%    773.55 Mbps    544.19 Mbps    i3D.net - Singapore
 Tokyo, JP        212.38 ms   25.8%   311.19 Mbps    307.26 Mbps    GSL Networks - Tokyo
---------------------------------------------------------------------------
 Avg DL Speed       : 955.03 Mbps
 Avg UL Speed       : 784.59 Mbps

 Total DL Data      : 33.51 GB (34313.7 MB)
 Total UL Data      : 23.50 GB (24063.4 MB)
 Total Data         : 57.01 GB (58377.1 MB)
---------------------------------------------------------------------------
 Finished in        : 12 min 4 sec
 Timestamp          : 11-02-2023 10:31:53 UTC
---------------------------------------------------------------------------
```

## Bandwidth Usage 
The script usually takes around 10-15 minutes to complete execution.\
Data usage is hard to estimate since it is completely dependant on the connection and location.\
However, below is a very rough estimate - based on a few tests on different networks.

| Port Speed (DL/UL) | Data Used | Country 
|--|--|--|
|10Gbps Symmetric    | ~130GB | SG |
|5Gbps Symmetric     | ~60GB  | KR |
|1Gbps Symmetric     | ~40GB  | US |
|750Mbps Symmetric   | ~35GB  | DE |
|500Mbps Symmetric   | ~25GB  | IN |
|100Mbps Symmetric   | ~6GB   | US |
|--|--|--|
|2Gbps/250Mbps       | ~50GB  | DE |
|1Gbps/250Mbps       | ~35GB  | CA |