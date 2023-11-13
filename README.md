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
      - Middle East
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
 Version            : v2023.11.13
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
 Total Disk         : 9.3 GB (4.7 GB Used)
 Total RAM          : 451.8 MB (145.5 MB Used)
 Total Swap         : 1024.0 MB (19.5 MB Used)
 System uptime      : 20 days, 20 hour 41 min
 Load average       : 0.10, 0.12, 0.09
 OS                 : Debian GNU/Linux 12
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.1.0-10-amd64
 Virtualization     : MICROSOFT
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
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

 Nearest          0.35 ms     N/A     7300.45 Mbps   6933.75 Mbps   Netprotect - Frankfurt

 Kochi, IN        159.48 ms   0.3%    1459.82 Mbps   315.04 Mbps    Asianet Broadband - Cochin
 Bangalore, IN    157.37 ms   0.0%    5284.20 Mbps   401.48 Mbps    Bharti Airtel Ltd - Bangalore
 Chennai, IN      136.23 ms   N/A     3149.75 Mbps   531.86 Mbps    Jio - Chennai
 Mumbai, IN       154.50 ms   0.0%    3619.55 Mbps   356.70 Mbps    i3D.net - Mumbai
 Delhi, IN        176.92 ms   0.0%    1855.95 Mbps   326.83 Mbps    Tata Teleservices Ltd - New Delhi

 Seattle, US      154.51 ms   N/A     5147.97 Mbps   367.07 Mbps    Comcast - Seattle, WA
 Los Angeles, US  140.80 ms   0.0%    4171.92 Mbps   484.00 Mbps    ReliableSite Hosting - Los Angeles, CA
 Dallas, US       114.10 ms   0.0%    1462.60 Mbps   1060.46 Mbps   Hivelocity - Dallas, TX
 Miami, US        114.77 ms   0.0%    540.83 Mbps    841.71 Mbps    AT&T - Miami, FL
 New York, US     77.47 ms    0.0%    1111.33 Mbps   1572.51 Mbps   GSL Networks - New York, NY
 Toronto, CA      99.76 ms    0.0%    3340.15 Mbps   761.06 Mbps    Rogers - Toronto, ON

 London, UK       13.29 ms    0.0%    1518.03 Mbps   4729.92 Mbps   VeloxServ Communications - London
 Amsterdam, NL    8.06 ms     0.0%    1724.37 Mbps   5010.59 Mbps   31173 Services AB - Amsterdam
 Paris, FR        11.26 ms    0.0%    1814.50 Mbps   4910.65 Mbps   Axione - Paris
 Frankfurt, DE    0.71 ms     0.0%    6677.77 Mbps   5637.42 Mbps   23M GmbH - Frankfurt am Main
 Warsaw, PL       20.50 ms    0.0%    3935.68 Mbps   3760.08 Mbps   UPC Polska - Warszawa
 Bucharest, RO    28.84 ms    0.0%    3702.69 Mbps   2633.95 Mbps   Vodafone Romania Fixed – Bucharest - Bucharest

 Jeddah, SA       68.81 ms    0.0%    1544.08 Mbps   1529.36 Mbps   Saudi Telecom Company
 Dubai, AE        129.41 ms   0.0%    2030.13 Mbps   709.97 Mbps    du - Dubai
 Fujairah, AE     111.42 ms   0.0%    1075.53 Mbps   1069.90 Mbps   ETISALAT-UAE - Fujairah

 Tokyo, JP        252.68 ms   N/A     1092.10 Mbps   117.95 Mbps    fdcservers.net - Tokyo
 Shanghai, CU-CN  251.73 ms   0.0%    255.51 Mbps    297.89 Mbps    China Unicom 5G - Shanghai
 Nanjing, CT-CN   232.57 ms   4.7%    802.23 Mbps    156.29 Mbps    China Telecom JiangSu 5G - Nanjing
 Hong Kong, CN    169.09 ms   N/A     2668.89 Mbps   433.96 Mbps    STC - Hong Kong
 Singapore, SG    321.90 ms   0.0%    2420.56 Mbps   252.71 Mbps    i3D.net - Singapore
 Jakarta, ID      186.61 ms   0.0%    2775.35 Mbps   295.97 Mbps    PT. Telekomunikasi Indonesia - Jakarta
---------------------------------------------------------------------------
 Avg DL Speed       : 2684.52 Mbps
 Avg UL Speed       : 1685.16 Mbps

 Total DL Data      : 94.97 GB
 Total UL Data      : 60.95 GB
 Total Data         : 155.91 GB
---------------------------------------------------------------------------
 Duration           : 13 min 12 sec
 System Time        : 13/11/2023 - 14:57:41 UTC
 Total Script Runs  : 26989
---------------------------------------------------------------------------
 Result             : https://result.network-speed.xyz/r/1699886944_1G6LDH_GLOBAL.txt
---------------------------------------------------------------------------
```

## Sample Output (Regional)
```
---------------------------- network-speed.xyz ----------------------------
      A simple script to test network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2023.11.13
 Global Speedtest   : wget -qO- network-speed.xyz | bash
 Region Speedtest   : wget -qO- network-speed.xyz | bash -s -- -r <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD EPYC-Rome Processor
 CPU Cores          : 16 @ 2799.998 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 1.2 TB (399.3 GB Used)
 Total RAM          : 62.8 GB (1.8 GB Used)
 System uptime      : 10 days, 20 hour 23 min
 Load average       : 0.31, 0.30, 0.22
 OS                 : Ubuntu 22.04.3 LTS
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.15.0-88-generic
 Virtualization     : KVM
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
 ISP                : HIVELOCITY, Inc.
 ASN                : AS29802 HIVELOCITY, Inc.
 Host               : HIVELOCITY, Inc.
 Location           : Tampa, Florida-FL, United States
 Location (IPv4)    : New York City, New York, US
---------------------------------------------------------------------------
 Speedtest.net (Region: NORTH AMERICA)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: HIVELOCITY

 Nearest          32.13 ms    0.0%    969.65 Mbps    979.59 Mbps    Ideatek Telcom - Wichita, KS

 Vancouver, BC    60.61 ms    N/A     967.70 Mbps    1135.93 Mbps   TELUS - Vancouver, BC
 Calgary, AB      71.34 ms    N/A     979.29 Mbps    1150.40 Mbps   Shaw Communications - Calgary, AB
 Winnipeg, MB     33.30 ms    0.0%    981.48 Mbps    1033.50 Mbps   Voyageur Internet - Winnipeg, MB
 Toronto, ON      13.33 ms    0.0%    966.90 Mbps    1030.24 Mbps   Bell Canada - Toronto, ON
 Montreal, QC     18.62 ms    0.0%    965.83 Mbps    1033.81 Mbps   Rogers Wireless - Montréal, QC

 New York, NY     1.91 ms     0.0%    978.59 Mbps    1020.65 Mbps   Surfshark Ltd - New York, NY
 Ashburn, VA      8.02 ms     0.0%    978.66 Mbps    1025.62 Mbps   Rackdog - Ashburn, VA
 Charlotte, NC    29.94 ms    0.0%    982.01 Mbps    1017.43 Mbps   Windstream - Charlotte, NC
 Atlanta, GA      21.22 ms    0.0%    966.61 Mbps    1034.20 Mbps   i3D.net - Atlanta, GA
 Miami, FL        37.02 ms    0.0%    980.75 Mbps    1027.54 Mbps   AT&T - Miami, FL
 Dallas, TX       38.83 ms    0.0%    964.68 Mbps    1033.02 Mbps   Hivelocity - Dallas, TX
 Houston, TX      36.96 ms    0.0%    980.87 Mbps    1002.22 Mbps   Ezee Fiber - Houston, TX
 Kansas, MO       27.70 ms    0.0%    976.04 Mbps    986.15 Mbps    Xiber LLC - Kansas City, MO
 Minneapolis, MN  26.28 ms    0.0%    979.99 Mbps    1039.35 Mbps   US Internet - Minneapolis, MN
 Chicago, IL      19.75 ms    0.0%    968.92 Mbps    1029.48 Mbps   Enzu.com - Chicago, IL
 Cleveland, OH    18.24 ms    0.0%    981.91 Mbps    1030.18 Mbps   Windstream - Cleveland, OH
 Albuquerque, NM  47.87 ms    N/A     972.68 Mbps    924.90 Mbps    Comcast - Albuquerque, NM
 Denver, CO       42.72 ms    0.0%    970.74 Mbps    1028.73 Mbps   T-Mobile Fiber | Intrepid - Denver, CO
 Portland, OR     74.28 ms    N/A     994.76 Mbps    1064.18 Mbps   CenturyLink - Portland, OR
 Las Vegas, NV    72.70 ms    N/A     989.92 Mbps    1122.41 Mbps   Dish Wireless - Las Vegas, NV
 Salt Lake, UT    60.37 ms    N/A     949.70 Mbps    1114.76 Mbps   Novva Data Centers - Salt Lake City, UT
 Phoenix, AZ      56.70 ms    0.0%    984.85 Mbps    1081.14 Mbps   Xiber LLC - Phoenix, AZ
 Los Angeles, CA  63.88 ms    0.0%    977.44 Mbps    1097.49 Mbps   ReliableSite Hosting - Los Angeles, CA
 San Jose, CA     62.98 ms    0.0%    946.84 Mbps    1067.08 Mbps   Misaka Network, Inc. - San Jose, CA
 Seattle, WA      64.65 ms    0.0%    964.93 Mbps    1072.61 Mbps   Misaka Network, Inc. - Seattle, WA
 Anchorage, AK    95.29 ms    0.0%    939.39 Mbps    281.60 Mbps    Alaska Communications - Anchorage, AK

 Hermosillo, MX   79.29 ms    0.0%    979.21 Mbps    1129.69 Mbps   Megacable - Hermosillo
 Guadalajara, MX  82.03 ms    0.0%    962.44 Mbps    524.70 Mbps    AT&T México - Guadalajara
 Mexico City, MX  89.17 ms    N/A     972.72 Mbps    790.31 Mbps    INFINITUM - Mexico City
---------------------------------------------------------------------------
 Avg DL Speed       : 972.51 Mbps
 Avg UL Speed       : 996.96 Mbps

 Total DL Data      : 35.81 GB
 Total UL Data      : 40.86 GB
 Total Data         : 76.67 GB
---------------------------------------------------------------------------
 Duration           : 12 min 31 sec
 System Time        : 13/11/2023 - 14:59:22 UTC
 Total Script Runs  : 26990
---------------------------------------------------------------------------
 Result             : https://result.network-speed.xyz/r/1699887044_OLENJV_NA.txt
---------------------------------------------------------------------------
```

## Sample Output (All Regions)
NA          : https://result.network-speed.xyz/r/1694522045_QVORYM_NA.txt <br>
SA          : https://result.network-speed.xyz/r/1694528715_JFU3T1_SA.txt <br>
EU          : https://result.network-speed.xyz/r/1694529083_9KFDDK_EU.txt <br>
Asia        : https://result.network-speed.xyz/r/1694528694_SIR554_ASIA.txt <br>
Africa      : https://result.network-speed.xyz/r/1694537113_747AYT_AFRICA.txt <br>
AU          : https://result.network-speed.xyz/r/1694536652_DGXND8_AU.txt <br>
Middle East : https://result.network-speed.xyz/r/1699886816_J28SZ3_MIDDLE-EAST.txt <br>
India       : https://result.network-speed.xyz/r/1694530534_3C9IAU_INDIA.txt <br>
China       : https://result.network-speed.xyz/r/1694528635_EI46XX_CHINA.txt <br>
Iran        : https://result.network-speed.xyz/r/1694528246_6GOL8A_IRAN.txt <br>
Indonesia   : https://result.network-speed.xyz/r/1695397374_P9DYIL_INDONESIA.txt <br>

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

## Donations
<a href="https://www.buymeacoffee.com/shsky97" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
