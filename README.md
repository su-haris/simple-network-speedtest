# A simple script for benchmarking network performance with speedtest-cli

Your Reliable Script for Comprehensive Network Performance Testing.

## Features
   - System Overview: Quick snapshot of your device's core hardware components like CPU, RAM, Disk and more.
   - Network Overview: Detailed information including your protocol type (IPv4/v6), ISP, geographical location and other network-based data.
   - Comprehensive Speedtest: Perform an all-encompassing speedtest using the renowned Ookla speedtest.net service to servers around the world, presenting metrics such as speed, latency and packet loss.
   - Global High Speedtest: Check your ISPs performance with 10G+ servers across the world.
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
      - Russia
      - And more coming soon!
   - Statistical Insights: At-a-glance summary of your network's performance metrics, including speed, data usage, and test duration.
   - Shareability: Want to share your results? No worries, each test provides you with a handy shareable link.

I would like to express my heartfelt thanks to our awesome sponsors for their invaluable support:
- [Crunchbits](https://zip.xbit.win/go/crunchbits) for generously sponsoring the hosting infrastructure.
- [IncogNET](https://zip.xbit.win/go/incognet) for kindly sponsoring the domain name.

Thanks to Teddysun <i@teddysun.com> for the base bench.sh script.

## Usage

### Global Speedtest (default)
```
curl -sL nws.sh | bash
```
```
wget -qO- nws.sh | bash
```

### Regional Speedtest
region_name = na, sa, eu, asia, africa, au, middle-east, india, china, iran, indonesia, russia
```
curl -sL nws.sh | bash -s -- -r region_name
```
```
wget -qO- nws.sh | bash -s -- -r region_name
```

### Example:
```
wget -qO- nws.sh | bash -s -- -r india
```

## Sample Output (Global)
```
---------------------------------- nws.sh ---------------------------------
      A simple script to bench network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2024.09.18
 Global Speedtest   : wget -qO- nws.sh | bash
 Region Speedtest   : wget -qO- nws.sh | bash -s -- -r <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD EPYC 7542 32-Core Processor
 CPU Cores          : 1 @ 2899.998 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 19.6 GB (6.2 GB Used)
 Total RAM          : 1.9 GB (507.8 MB Used)
 System uptime      : 11 days, 15 hour 36 min
 Load average       : 0.22, 0.16, 0.11
 OS                 : Debian GNU/Linux 12
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.1.0-25-cloud-amd64
 Virtualization     : KVM
 TCP Control        : cubic
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
 ISP                : SkyInfo Networks - EU
 ASN                : AS198383 Suhail Haris
 ASN (IPv4)         : AS200461 Ian David Klemm
 Host               : SkyInfo Networks
 Location           : Frankfurt Am Main, Hesse-HE, Germany
---------------------------------------------------------------------------
 Speedtest.net (Region: GLOBAL)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: combahton IT Services

 Nearest          1.53 ms     0.0%    1538.39 Mbps   3485.22 Mbps   Server.camp - Kassel

 Kochi, IN        166.44 ms   0.0%    3736.77 Mbps   537.86 Mbps    Asianet Broadband - Cochin
 Bangalore, IN    147.07 ms   0.0%    4222.72 Mbps   627.56 Mbps    Bharti Airtel Ltd - Bangalore
 Chennai, IN      192.24 ms   N/A     3943.43 Mbps   399.14 Mbps    Jio - Chennai
 Mumbai, IN       110.23 ms   0.0%    3995.79 Mbps   413.16 Mbps    i3D.net - Mumbai
 Delhi, IN        147.62 ms   0.0%    4183.13 Mbps   553.48 Mbps    Tata Play Fiber - New Delhi

 Seattle, US      153.20 ms   N/A     3157.31 Mbps   607.57 Mbps    Comcast - Seattle, WA
 Los Angeles, US  152.46 ms   0.0%    4063.23 Mbps   589.52 Mbps    ReliableSite Hosting - Los Angeles, CA
 Dallas, US       115.32 ms   0.0%    3224.30 Mbps   616.81 Mbps    i3D.net - Dallas, TX
 Miami, US        126.78 ms   N/A     3274.83 Mbps   465.58 Mbps    Dish Wireless - Miami, FL
 New York, US     77.58 ms    0.0%    4310.57 Mbps   863.69 Mbps    GSL Networks - New York, NY
 Toronto, CA      104.44 ms   0.0%    3454.32 Mbps   874.17 Mbps    Rogers - Toronto, ON
 Mexico City, MX  188.14 ms   N/A     3008.39 Mbps   477.59 Mbps    INFINITUM - Mexico City

 London, UK       11.59 ms    0.5%    5934.77 Mbps   3436.04 Mbps   VeloxServ Communications - London
 Amsterdam, NL    46.99 ms    0.0%    4845.98 Mbps   1336.57 Mbps   31173 Services AB - Amsterdam
 Paris, FR        9.47 ms     N/A     6179.83 Mbps   3373.56 Mbps   Axione - Paris
 Frankfurt, DE    1.11 ms     1.4%    6050.13 Mbps   7907.77 Mbps   Clouvider Ltd - Frankfurt am Main
 Warsaw, PL       19.04 ms    0.0%    5951.63 Mbps   2683.64 Mbps   Play - Warszawa
 Bucharest, RO    28.16 ms    0.0%    5332.86 Mbps   1424.27 Mbps   Vodafone Romania Fixed – Bucharest - Bucharest
 Moscow, RU       39.87 ms    0.0%    4878.17 Mbps   599.71 Mbps    RETN - Moscow

 Jeddah, SA       80.96 ms    0.0%    4314.31 Mbps   919.52 Mbps    Saudi Telecom Company
 Dubai, AE        249.58 ms   0.3%    3057.73 Mbps   399.17 Mbps    du - Dubai
 Fujairah, AE     113.12 ms   0.3%    4683.14 Mbps   836.59 Mbps    e& UAE - Fujairah
 Istanbul, TR     40.35 ms    0.0%    6128.18 Mbps   1240.84 Mbps   Turkcell - Istanbul
 Tehran, IR       108.81 ms   0.0%    1.88 Mbps      768.03 Mbps    Asiatech - Tehran

 Tokyo, JP        216.49 ms   0.3%    3677.67 Mbps   418.43 Mbps    IPA CyberLab 400G - Tokyo
 Shanghai, CU-CN  160.64 ms   0.0%    3146.95 Mbps   589.04 Mbps    China Unicom 5G - Shanghai
 Nanjing, CT-CN   259.03 ms   0.0%    1995.98 Mbps   16.12 Mbps     China Telecom JiangSu 5G - Nanjing
 Hong Kong, CN    161.82 ms   N/A     2786.19 Mbps   142.35 Mbps    STC - Hong Kong
 Singapore, SG    153.11 ms   0.0%    3535.88 Mbps   615.64 Mbps    i3D.net - Singapore
 Jakarta, ID      FAILED - IP has been rate limited. Try again after 1 hour.
---------------------------------------------------------------------------
 Avg DL Speed       : 3953.83 Mbps
 Avg UL Speed       : 1240.62 Mbps

 Total DL Data      : 161.08 GB
 Total UL Data      : 47.02 GB
 Total Data         : 208.10 GB
---------------------------------------------------------------------------
 Duration           : 14 min 47 sec
 System Time        : 18/09/2024 - 04:58:22 UTC
 Total Script Runs  : 81339
---------------------------------------------------------------------------
 Result             : https://result.nws.sh/r/1726634936_1UHCUP_GLOBAL.txt
---------------------------------------------------------------------------
```

## Sample Output (Regional)
```
---------------------------------- nws.sh ---------------------------------
      A simple script to bench network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2024.09.18
 Global Speedtest   : wget -qO- nws.sh | bash
 Region Speedtest   : wget -qO- nws.sh | bash -s -- -r <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : Intel Xeon Processor (Skylake, IBRS)
 CPU Cores          : 1 @ 2095.066 MHz
 CPU Cache          : 16384 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 39.9 GB (8.2 GB Used)
 Total RAM          : 1.4 GB (470.0 MB Used)
 System uptime      : 78 days, 3 hour 9 min
 Load average       : 0.00, 0.02, 0.00
 OS                 : Debian GNU/Linux 12
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.1.0-22-amd64
 Virtualization     : KVM
 TCP Control        : cubic
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
 ISP                : Redoubt Networks
 ASN                : AS400304 Redoubt Networks
 Host               : Redoubt Networks
 Location           : Allentown, Pennsylvania-PA, United States
---------------------------------------------------------------------------
 Speedtest.net (Region: NORTH AMERICA)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: Redoubt-net

 Nearest          2.99 ms     0.0%    929.09 Mbps    1007.28 Mbps   WiLine Networks - Philadelphia, PA

 Vancouver, BC    70.62 ms    N/A     859.97 Mbps    1079.23 Mbps   TELUS - Vancouver, BC
 Calgary, AB      49.38 ms    N/A     658.01 Mbps    1002.12 Mbps   Shaw Communications - Calgary, AB
 Winnipeg, MB     43.20 ms    0.0%    866.58 Mbps    1006.04 Mbps   Voyageur Internet - Winnipeg, MB
 Toronto, ON      26.83 ms    0.0%    916.13 Mbps    944.60 Mbps    Bell Canada - Toronto, ON
 Montreal, QC     14.56 ms    0.0%    918.76 Mbps    1009.42 Mbps   Rogers Wireless - Montréal, QC

 New York, NY     4.55 ms     0.0%    893.90 Mbps    999.43 Mbps    Surfshark Ltd - New York, NY
 Ashburn, VA      6.31 ms     0.0%    938.19 Mbps    1000.51 Mbps   Rackdog - Ashburn, VA
 Charlotte, NC    24.40 ms    N/A     901.86 Mbps    922.23 Mbps    Windstream - Charlotte, NC
 Atlanta, GA      22.00 ms    0.0%    916.29 Mbps    1008.97 Mbps   i3D.net - Atlanta, GA
 Miami, FL        91.37 ms    0.0%    877.77 Mbps    810.58 Mbps    ReliableSite Hosting - Miami, FL
 Dallas, TX       36.29 ms    0.0%    806.34 Mbps    999.56 Mbps    i3D.net - Dallas, TX
 Houston, TX      40.34 ms    0.0%    785.91 Mbps    1008.93 Mbps   AT&T - Houston, TX
 Kansas, MO       46.15 ms    0.0%    723.24 Mbps    982.30 Mbps    Nocix - Kansas City, MO
 Minneapolis, MN  36.03 ms    0.0%    862.78 Mbps    1015.78 Mbps   US Internet - Minneapolis, MN
 Chicago, IL      19.94 ms    0.0%    914.02 Mbps    1014.59 Mbps   Enzu.com - Chicago, IL
 Cleveland, OH    19.78 ms    N/A     898.76 Mbps    1012.59 Mbps   Windstream - Cleveland, OH
 Albuquerque, NM  49.97 ms    N/A     887.31 Mbps    965.53 Mbps    Comcast - Albuquerque, NM
 Denver, CO       39.88 ms    0.0%    824.66 Mbps    1012.96 Mbps   T-Mobile Fiber | Intrepid - Denver, CO
 Portland, OR     72.37 ms    N/A     946.37 Mbps    1049.94 Mbps   CenturyLink - Portland, OR
 Las Vegas, NV    73.80 ms    N/A     813.99 Mbps    1058.74 Mbps   Dish Wireless - Las Vegas, NV
 Salt Lake, UT    56.21 ms    N/A     824.12 Mbps    1036.94 Mbps   Novva Data Centers - Salt Lake City, UT
 Phoenix, AZ      56.33 ms    0.0%    920.27 Mbps    1008.23 Mbps   Xiber LLC - Phoenix, AZ
 Los Angeles, CA  80.91 ms    0.0%    802.24 Mbps    1090.30 Mbps   ReliableSite Hosting - Los Angeles, CA
 San Jose, CA     65.45 ms    0.0%    826.58 Mbps    967.50 Mbps    Misaka Network, Inc. - San Jose, CA
 Spokane, WA      62.10 ms    0.0%    764.26 Mbps    197.84 Mbps    Crunchbits - Spokane, WA
 Seattle, WA      67.48 ms    0.4%    816.60 Mbps    1041.85 Mbps   Misaka Network, Inc. - Seattle, WA

 Hermosillo, MX   94.76 ms    0.0%    893.83 Mbps    922.73 Mbps    Megacable - Hermosillo
 Guadalajara, MX  62.68 ms    0.0%    877.63 Mbps    426.78 Mbps    AT&T México - Guadalajara
 Mexico City, MX  105.54 ms   N/A     825.10 Mbps    727.80 Mbps    INFINITUM - Mexico City
---------------------------------------------------------------------------
 Avg DL Speed       : 856.35 Mbps
 Avg UL Speed       : 944.37 Mbps

 Total DL Data      : 30.49 GB
 Total UL Data      : 40.58 GB
 Total Data         : 71.07 GB
---------------------------------------------------------------------------
 Duration           : 12 min 29 sec
 System Time        : 17/09/2024 - 22:37:04 IST
 Total Script Runs  : 81298
---------------------------------------------------------------------------
 Result             : https://result.nws.sh/r/1726592547_C6E62V_NA.txt
---------------------------------------------------------------------------
```

## Sample Output (All Regions)
NA          : https://result.nws.sh/r/1726636198_ZB7UZ4_NA.txt <br>
SA          : https://result.nws.sh/r/1726636253_DOOLEN_SA.txt <br>
EU          : https://result.nws.sh/r/1726636063_M5C2V5_EU.txt <br>
Asia        : https://result.nws.sh/r/1726636719_94JGP0_ASIA.txt <br>
Africa      : https://result.nws.sh/r/1726635505_DDM2VB_AFRICA.txt <br>
AU          : https://result.nws.sh/r/1726635412_6451TY_AU.txt <br>
Middle East : https://result.nws.sh/r/1726637205_6D2MTS_MIDDLE-EAST.txt <br>
India       : https://result.nws.sh/r/1726636009_9Q49NL_INDIA.txt <br>
China       : https://result.nws.sh/r/1694528635_EI46XX_CHINA.txt <br>
Iran        : https://result.nws.sh/r/1726636450_GZ5PBE_IRAN.txt <br>
Indonesia   : https://result.nws.sh/r/1695397374_P9DYIL_INDONESIA.txt <br>
Russia      : https://result.nws.sh/r/1726589517_CS2RMK_RUSSIA.txt <br>

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
If you'd like to show your support or appreciation for this project, consider making a donation. Your generosity is greatly appreciated! <br><br>
Monero      / XMR : 42whZjNSwLSZ7vtYXwUTUZd8xmNWa8EzYhfCBDYMP5jkgn3orztgUjvaZ5CCZuWqmaPgTMBRFdVASjesq3g4KWfKEEqwgbZ <br>
Litecoin    / LTC : LRisSqwatDjNDY5Cf7QNcKKjk89riq4VbX
<!-- <a href="https://www.buymeacoffee.com/shsky97" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a> -->
