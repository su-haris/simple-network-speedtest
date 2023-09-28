# A simple script for benchmarking network performance with speedtest-cli
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fnetwork-speed.xyz&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com)

Your Reliable Script for Comprehensive Network Performance Testing.

## Features
   - System Overview: Quick snapshot of your device's core hardware components like CPU, RAM, Disk and more.
   - Network Overview: Detailed information including your protocol type (IPv4/v6), ISP, geographical location and other network-based data.
   - Comprehensive Speedtest: Perform an all-encompassing speedtest using the renowned Ookla speedtest.net service to servers around the world, presenting metrics such as speed, latency and packet loss.
   - Regional Speedtest: Get a regional perspective towards your network performance with tests targeted towards specific parts of the world, currently including:
      - North America
      - South America
      - Europe
      - Asia
      - Africa
      - Australia
      - GCC Middle East
      - India
      - China
      - Iran
      - Indonesia
      - And more coming soon!
   - Statistical Insights: At-a-glance summary of your network's performance metrics, including speed, data usage, and test duration.
   - Shareability: Want to share your results? No worries, each test provides you with a handy shareable link.

Big Thanks and shout out to [Crunchbits LLC](https://zip.xbit.win/go/crunchbits) for sponsoring the Hosting Infrastructure.<br>
Thanks to Teddysun <i@teddysun.com> for the base bench.sh script.

## Usage

### Global Speedtest (default)
```
curl -sL network-speed.xyz | bash
```
```
wget -qO- network-speed.xyz | bash
```

### Regional Speedtest
region_name = na, sa, eu, asia, africa, au, middle-east, india, china, iran, indonesia
```
curl -sL network-speed.xyz | bash -s -- -r region_name
```
```
wget -qO- network-speed.xyz | bash -s -- -r region_name
```

### Example:
```
wget -qO- network-speed.xyz | bash -s -- -r india
```

## Sample Output (Global)
```
---------------------------- network-speed.xyz ----------------------------
      A simple script to test network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2023.09.04
 Global Speedtest   : wget -qO- network-speed.xyz | bash
 Region Speedtest   : wget -qO- network-speed.xyz | bash -s -- -r <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : Intel Xeon Processor (Skylake, IBRS)
 CPU Cores          : 1 @ 2593.906 MHz
 CPU Cache          : 16384 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ❌ Disabled
 Total Disk         : 9.3 GB (5.1 GB Used)
 Total RAM          : 461.3 MB (89.1 MB Used)
 Total Swap         : 1024.0 MB (22.7 MB Used)
 System uptime      : 2 days, 18 hour 44 min
 Load average       : 0.26, 0.16, 0.10
 OS                 : Debian GNU/Linux 11
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.10.0-25-amd64
 Virtualization     : MICROSOFT
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 ISP                : SkyInfo Networks
 ASN                : AS198383 Suhail Haris
 ASN (IPv4)         : AS20473 The Constant Company, LLC
 Host               : SkyInfo Networks
 Location           : Frankfurt, Hesse-HE, Germany
---------------------------------------------------------------------------
 Speedtest.net (Region: GLOBAL)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: SkyInfo Networks

 Nearest          0.65 ms     N/A     5825.81 Mbps   4367.15 Mbps   Netprotect - Frankfurt

 Kochi, IN        166.39 ms   0.0%    1534.84 Mbps   332.29 Mbps    Asianet Broadband - Cochin
 Bangalore, IN    165.97 ms   0.0%    4838.29 Mbps   301.89 Mbps    Bharti Airtel Ltd - Bangalore
 Chennai, IN      144.35 ms   N/A     2369.05 Mbps   490.77 Mbps    Jio - Chennai
 Mumbai, IN       159.55 ms   0.0%    2441.16 Mbps   347.43 Mbps    i3D.net - Mumbai
 Delhi, IN        182.50 ms   0.0%    1748.42 Mbps   265.91 Mbps    Tata Teleservices Ltd - New Delhi

 Seattle, US      144.21 ms   0.0%    1880.66 Mbps   693.76 Mbps    Ziply Fiber - Seattle, WA
 Los Angeles, US  146.02 ms   0.0%    3555.92 Mbps   459.52 Mbps    ReliableSite Hosting - Los Angeles, CA
 Dallas, US       114.84 ms   0.0%    1359.02 Mbps   625.42 Mbps    Hivelocity - Dallas, TX
 Miami, US        117.13 ms   0.0%    832.79 Mbps    697.95 Mbps    AT&T - Miami, FL
 New York, US     79.25 ms    0.0%    1424.08 Mbps   922.86 Mbps    GSL Networks - New York, NY
 Toronto, CA      91.89 ms    0.0%    3554.54 Mbps   596.88 Mbps    Rogers - Toronto, ON

 London, UK       13.27 ms    0.0%    1638.93 Mbps   2453.90 Mbps   VeloxServ Communications - London
 Amsterdam, NL    8.39 ms     0.0%    2266.10 Mbps   3434.54 Mbps   31173 Services AB - Amsterdam
 Paris, FR        11.42 ms    N/A     2249.74 Mbps   3654.48 Mbps   Axione - Paris
 Frankfurt, DE    0.91 ms     0.0%    5753.63 Mbps   3310.13 Mbps   23M GmbH - Frankfurt am Main
 Warsaw, PL       19.52 ms    0.0%    2580.89 Mbps   3198.52 Mbps   UPC Polska - Warszawa
 Bucharest, RO    27.67 ms    0.0%    3549.34 Mbps   2232.75 Mbps   Vodafone Romania Fixed – Bucharest - Bucharest

 Jeddah, SA       73.54 ms    0.0%    3740.51 Mbps   1100.64 Mbps   Saudi Telecom Company
 Dubai, AE        139.74 ms   0.0%    1398.81 Mbps   614.05 Mbps    du - Dubai
 Fujairah, AE     112.11 ms   0.0%    1500.53 Mbps   775.26 Mbps    ETISALAT-UAE - Fujairah

 Tokyo, JP        235.93 ms   N/A     24.83 Mbps     468.72 Mbps    fdcservers.net - Tokyo
 Shanghai, CU-CN  258.23 ms   0.0%    455.67 Mbps    274.77 Mbps    China Unicom 5G - Shanghai
 Nanjing, CT-CN   FAILED
 Hong Kong, CN    162.22 ms   N/A     4250.26 Mbps   337.73 Mbps    STC - Hong Kong
 Singapore, SG    184.25 ms   0.0%    4020.46 Mbps   231.34 Mbps    i3D.net - Singapore
 Jakarta, ID      181.16 ms   0.0%    3412.86 Mbps   268.35 Mbps    PT. Telekomunikasi Indonesia - Jakarta
---------------------------------------------------------------------------
 Avg DL Speed       : 2623.35 Mbps
 Avg UL Speed       : 1248.34 Mbps

 Total DL Data      : 102.32 GB
 Total UL Data      : 42.85 GB
 Total Data         : 145.17 GB
---------------------------------------------------------------------------
 Duration           : 13 min 25 sec
 System Time        : 12/09/2023 - 12:54:43 UTC
 Total Script Runs  : 23045
---------------------------------------------------------------------------
 Result             : https://result.network-speed.xyz/r/1694523284_GP4IDB_GLOBAL.txt
---------------------------------------------------------------------------
```

## Sample Output (Regional)
```
---------------------------- network-speed.xyz ----------------------------
      A simple script to test network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2023.09.04
 Global Speedtest   : wget -qO- network-speed.xyz | bash
 Region Speedtest   : wget -qO- network-speed.xyz | bash -s -- -r <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD Ryzen 9 3900X 12-Core Processor
 CPU Cores          : 1 @ 3799.998 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 19.6 GB (2.7 GB Used)
 Total RAM          : 457.8 MB (73.2 MB Used)
 Total Swap         : 1024.0 MB (8.5 MB Used)
 System uptime      : 11 days, 19 hour 16 min
 Load average       : 0.00, 0.00, 0.00
 OS                 : Debian GNU/Linux 12
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.1.0-11-amd64
 Virtualization     : KVM
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 ISP                : IncogNET LLC
 ASN                : AS210630 IncogNET LLC
 Host               : Incognet LLC
 Location           : Coeur d'Alene, Idaho-ID, United States
 Location (IPv4)    : Liberty Lake, Washington, US
---------------------------------------------------------------------------
 Speedtest.net (Region: NORTH AMERICA)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: IncogNET LLC

 Nearest          10.27 ms    0.0%    4388.07 Mbps   2078.65 Mbps   Intechtel - Managed IT Services - Coeur d'Alene, ID

 Vancouver, BC    14.23 ms    N/A     4254.83 Mbps   1868.32 Mbps   TELUS - Vancouver, BC
 Calgary, AB      25.67 ms    N/A     4364.03 Mbps   951.55 Mbps    Shaw Communications - Calgary, AB
 Winnipeg, MB     53.87 ms    0.0%    4272.62 Mbps   450.01 Mbps    Voyageur Internet - Winnipeg, MB
 Toronto, ON      57.44 ms    0.0%    4182.94 Mbps   426.85 Mbps    Bell Canada - Toronto, ON
 Montreal, QC     89.83 ms    0.0%    4156.79 Mbps   418.51 Mbps    Rogers Wireless - Montréal, QC

 New York, NY     77.75 ms    0.0%    3224.79 Mbps   517.52 Mbps    Surfshark Ltd - New York, NY
 Ashburn, VA      69.73 ms    0.0%    4216.00 Mbps   460.40 Mbps    Rackdog - Ashburn, VA
 Charlotte, NC    78.39 ms    0.0%    4039.11 Mbps   506.61 Mbps    Windstream - Charlotte, NC
 Atlanta, GA      70.17 ms    0.0%    3591.94 Mbps   302.66 Mbps    i3D.net - Atlanta, GA
 Miami, FL        90.52 ms    0.0%    2582.08 Mbps   495.01 Mbps    AT&T - Miami, FL
 Dallas, TX       68.19 ms    0.0%    3145.09 Mbps   445.25 Mbps    Hivelocity - Dallas, TX
 Houston, TX      64.35 ms    0.0%    3661.62 Mbps   514.67 Mbps    Ezee Fiber - Houston, TX
 Kansas, MO       51.98 ms    0.0%    3731.05 Mbps   824.11 Mbps    Xiber LLC - Kansas City, MO
 Minneapolis, MN  42.24 ms    0.0%    4137.50 Mbps   611.64 Mbps    US Internet - Minneapolis, MN
 Chicago, IL      57.96 ms    0.0%    3385.17 Mbps   563.70 Mbps    Enzu.com - Chicago, IL
 Cleveland, OH    65.96 ms    0.0%    3628.61 Mbps   628.28 Mbps    Windstream - Cleveland, OH
 Albuquerque, NM  52.43 ms    N/A     4213.14 Mbps   647.14 Mbps    Comcast - Albuquerque, NM
 Denver, CO       37.62 ms    0.0%    4383.44 Mbps   524.57 Mbps    T-Mobile Fiber | Intrepid - Denver, CO
 Portland, OR     14.54 ms    N/A     4342.97 Mbps   1669.50 Mbps   CenturyLink - Portland, OR
 Las Vegas, NV    37.90 ms    N/A     3785.99 Mbps   997.47 Mbps    Dish Wireless - Las Vegas, NV
 Salt Lake, UT    52.41 ms    N/A     3613.92 Mbps   837.56 Mbps    Novva Data Centers - Salt Lake City, UT
 Phoenix, AZ      51.21 ms    0.0%    4432.55 Mbps   757.47 Mbps    Xiber LLC - Phoenix, AZ
 Los Angeles, CA  35.60 ms    0.0%    4147.31 Mbps   921.31 Mbps    ReliableSite Hosting - Los Angeles, CA
 Santa Clara, CA  31.68 ms    0.0%    2812.62 Mbps   926.44 Mbps    AT&T - Santa Clara, CA
 San Jose, CA     30.04 ms    0.0%    3712.56 Mbps   1099.06 Mbps   Misaka Network, Inc. - San Jose, CA
 Seattle, WA      11.32 ms    0.0%    4219.65 Mbps   2260.36 Mbps   Misaka Network, Inc. - Seattle, WA

 Hermosillo, MX   65.15 ms    0.0%    3763.50 Mbps   595.44 Mbps    Megacable - Hermosillo
 Guadalajara, MX  87.52 ms    0.0%    1875.36 Mbps   449.49 Mbps    AT&T México - Guadalajara
 Mexico City, MX  79.24 ms    N/A     3946.76 Mbps   489.20 Mbps    INFINITUM - Mexico City
 Merida, MX       FAILED
---------------------------------------------------------------------------
 Avg DL Speed       : 3807.07 Mbps
 Avg UL Speed       : 807.96 Mbps

 Total DL Data      : 161.70 GB
 Total UL Data      : 35.72 GB
 Total Data         : 197.42 GB
---------------------------------------------------------------------------
 Duration           : 13 min 59 sec
 System Time        : 12/09/2023 - 18:04:05 IST
 Total Script Runs  : 23044
---------------------------------------------------------------------------
 Result             : https://result.network-speed.xyz/r/1694522045_QVORYM_NA.txt
---------------------------------------------------------------------------
```

## Bandwidth Usage 
The script usually takes around 10-15 minutes to complete execution.\
Data usage is hard to estimate since it is completely dependant on the connection and location.\
However, below is a very rough estimate - based on a few tests on different networks.

| Port Speed (DL/UL) | Data Used | Country | Test Region 
|--|--|--|--|
|10Gbps Symmetric    | ~130GB | SG | GLOBAL
|5Gbps Symmetric     | ~60GB  | KR | GLOBAL
|1Gbps Symmetric     | ~40GB  | US | GLOBAL
|750Mbps Symmetric   | ~35GB  | DE | GLOBAL
|500Mbps Symmetric   | ~25GB  | IN | GLOBAL
|100Mbps Symmetric   | ~6GB   | US | GLOBAL
|--|--|--|--|
|2Gbps/250Mbps       | ~50GB  | DE | GLOBAL
|1Gbps/250Mbps       | ~35GB  | CA | GLOBAL
|--|--|--|--|
|10Gbps Symmetric    | ~440GB | DE | EU
|10Gbps Symmetric    | ~400GB | NL | EU
|1Gbps Symmetric     | ~50GB  | UK | EU
|--|--|--|--|
|10Gbps Symmetric    | ~240GB | SG | ASIA
|--|--|--|--|
|10Gbps Symmetric    | ~150GB | SG | INDIA
|--|--|--|--|
|1Gbps Symmetric     | ~55GB  | US | NA
