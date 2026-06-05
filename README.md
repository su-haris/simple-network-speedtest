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
      - 10G+ Global Test
      - And more coming soon!
   - iperf3 Network Test: Run iperf3 send/receive benchmarks against public servers across US, EU, and APAC with per-server DL/UL speed and latency.
   - Ping & Routing Test: Test network routing and latency to various destinations worldwide with detailed path analysis, including specialized China routing tests with ISP line type detection.
   - Statistical Insights: At-a-glance summary of your network's performance metrics, including speed, data usage, and test duration.
   - Shareability: Want to share your results? No worries, each test provides you with a handy shareable link.

I would like to express my heartfelt thanks to our awesome sponsors for their invaluable support:
- [IncogNET](https://zip.xbit.win/go/incognet) for kindly sponsoring the domain name.
- [PureVoltage](https://purevoltage.com) for providing a dedicated 40G iperf3 test server.

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

### iperf3 Network Test
```
curl -sL nws.sh | bash -s -- -iperf
```
```
wget -qO- nws.sh | bash -s -- -iperf
```

### Ping & Routing Test
Test network routing and latency to various global destinations with detailed path analysis.
```
curl -sL nws.sh | bash -s -- -rt [region]
```
```
wget -qO- nws.sh | bash -s -- -rt [region]
```

Available routing test regions:
- `china` - China-specific routing with detailed ISP path analysis
- `asia` - Asian routing test points (Singapore, Japan, Hong Kong, India, Vietnam, etc.)
- `na` - North American routing test points (US, Canada)
- `eu` - European routing test points (UK, Germany, France, Netherlands, etc.)
- `au` - Australia & New Zealand routing test points
- `global` - Worldwide routing test (default if no region specified)

### Examples:
```
wget -qO- nws.sh | bash -s -- -rt eu
wget -qO- nws.sh | bash -s -- -rt asia
wget -qO- nws.sh | bash -s -- -rt china
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
 Version            : v2025.11.07
 Global Speedtest   : wget -qO- nws.sh | bash
 Region Speedtest   : wget -qO- nws.sh | bash -s -- -r <region>
 Ping & Routing     : wget -qO- nws.sh | bash -s -- -rt <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD EPYC 7702P 64-Core Processor
 CPU Cores          : 1 @ 1996.250 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 19.6 GB (2.6 GB Used)
 Total RAM          : 3.8 GB (506.8 MB Used)
 System uptime      : 68 days, 2 hour 31 min
 Load average       : 0.03, 0.02, 0.00
 OS                 : Debian GNU/Linux 13
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.12.48+deb13-amd64
 Virtualization     : KVM
 TCP Control        : cubic
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
 ISP                : HostBilby Inc
 ASN                : AS401665 HostBilby Inc.
 Host               : Zappie Host LLC
 Location           : Toronto, Ontario-ON, Canada
---------------------------------------------------------------------------
 Speedtest.net (Region: NORTH AMERICA)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server      

 ISP: HostBilby Inc. 

 Nearest          0.51 ms     0.0%    4253.70 Mbps   5271.91 Mbps   Primus - Toronto, ON 

 Vancouver, BC    48.49 ms    0.0%    4055.80 Mbps   1813.98 Mbps   TELUS - Vancouver, BC 
 Calgary, AB      54.69 ms    N/A     3914.26 Mbps   1622.73 Mbps   Shaw Communications - Calgary, AB 
 Winnipeg, MB     21.92 ms    0.0%    4372.90 Mbps   2573.29 Mbps   Voyageur Internet - Winnipeg, MB 
 Toronto, ON      0.61 ms     0.0%    4216.01 Mbps   5355.42 Mbps   Bell Canada - Toronto, ON 
 Montreal, QC     13.63 ms    0.0%    4358.92 Mbps   4204.46 Mbps   Rogers Wireless - Montréal, QC 

 New York, NY     11.38 ms    0.0%    4003.75 Mbps   3532.65 Mbps   Surfshark Ltd - New York, NY 
 Ashburn, VA      24.12 ms    0.0%    4208.72 Mbps   2275.72 Mbps   Rackdog - Ashburn, VA 
 Durham, NC       33.05 ms    0.0%    4216.61 Mbps   2254.75 Mbps   Spectrum - Durham, NC 
 Atlanta, GA      24.06 ms    0.0%    3998.24 Mbps   3592.89 Mbps   Clouvider Ltd - Atlanta, GA 
 Miami, FL        49.55 ms    0.0%    4206.59 Mbps   1228.01 Mbps   ReliableSite Hosting - Miami, FL 
 Dallas, TX       31.59 ms    0.0%    4013.59 Mbps   2373.16 Mbps   Hivelocity - Dallas, TX 
 Houston, TX      40.43 ms    N/A     4013.34 Mbps   2088.20 Mbps   Comcast - Houston, TX 
 Kansas, MO       23.20 ms    0.0%    4053.86 Mbps   1900.36 Mbps   Nocix - Kansas City, MO 
 Minneapolis, MN  18.46 ms    0.0%    4169.27 Mbps   2089.67 Mbps   US Internet - Minneapolis, MN 
 Chicago, IL      14.38 ms    0.0%    4143.26 Mbps   851.41 Mbps    Hivelocity - Chicago, IL 
 Cleveland, OH    21.61 ms    0.0%    3891.17 Mbps   3105.27 Mbps   Cleveland Broadband - Cleveland, OH 
 Albuquerque, NM  39.77 ms    N/A     3894.86 Mbps   2072.88 Mbps   Comcast - Albuquerque, NM 
 Denver, CO       36.15 ms    0.0%    4132.98 Mbps   2472.84 Mbps   T-Mobile Fiber | Intrepid - Denver, CO 
 Portland, OR     70.52 ms    N/A     4119.06 Mbps   1520.46 Mbps   CenturyLink - Portland, OR 
 Las Vegas, NV    82.12 ms    N/A     3308.57 Mbps   1093.68 Mbps   Boost Mobile - Las Vegas, NV 
 Salt Lake, UT    42.88 ms    0.0%    3905.92 Mbps   1296.98 Mbps   Novva Data Centers - Salt Lake City, UT 
 Phoenix, AZ      53.03 ms    0.0%    2396.27 Mbps   1554.83 Mbps   Xiber LLC - Phoenix, AZ 
 Los Angeles, CA  56.36 ms    0.0%    4162.41 Mbps   416.00 Mbps    ReliableSite Hosting - Los Angeles, CA 
 San Jose, CA     57.09 ms    0.0%    3727.91 Mbps   1796.35 Mbps   Misaka Network, Inc. - San Jose, CA 
 Spokane, WA      65.40 ms    0.0%    4067.73 Mbps   1473.49 Mbps   Crunchbits - Spokane, WA 
 Seattle, WA      49.52 ms    0.0%    4084.53 Mbps   1653.52 Mbps   Misaka Network, Inc. - Seattle, WA 

 Hermosillo, MX   67.11 ms    0.0%    3806.08 Mbps   1227.19 Mbps   Megacable - Hermosillo 
 Guadalajara, MX  65.87 ms    N/A     1883.14 Mbps   299.78 Mbps    AT&T México - Guadalajara 
 Mexico City, MX  78.69 ms    0.0%    4204.34 Mbps   753.58 Mbps    INFINITUM - Ciudad de México 
---------------------------------------------------------------------------
 Avg DL Speed       : 3926.13 Mbps
 Avg UL Speed       : 2125.53 Mbps

 Total DL Data      : 147.70 GB
 Total UL Data      : 83.31 GB
 Total Data         : 231.01 GB
---------------------------------------------------------------------------
 Duration           : 12 min 6 sec
 System Time        : 15/01/2026 - 14:55:36 IST
 Total Script Runs  : 516276
---------------------------------------------------------------------------
 Result             : https://result.nws.sh/r/1768469137_3NLHUS_NA.txt
---------------------------------------------------------------------------
```

## Sample Output (Ping & Routing)
```
---------------------------------- nws.sh ---------------------------------
      A simple script to bench network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2025.07.08
 Global Speedtest   : wget -qO- nws.sh | bash
 Region Speedtest   : wget -qO- nws.sh | bash -s -- -r <region>
 Ping & Routing     : wget -qO- nws.sh | bash -s -- -rt <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD Ryzen 9 3900X 12-Core Processor
 CPU Cores          : 1 @ 3799.998 MHz
 CPU Cache          : 512 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 19.1 GB (5.1 GB Used)
 Total RAM          : 712.5 MB (317.8 MB Used)
 Total Swap         : 512.0 MB (62.9 MB Used)
 System uptime      : 133 days, 0 hour 10 min
 Load average       : 0.00, 0.00, 0.00
 OS                 : Debian GNU/Linux 11
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.10.0-33-amd64
 Virtualization     : KVM
 TCP Control        : cubic
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv4
 IPv6 Access        : ❌ Offline
 IPv4 Access        : ✔ Online
 ISP                : xTom GmbH
 ASN                : AS3214 xTom GmbH
 Host               : Virtual Machine Solutions LLC
 Location           : Amsterdam, North Holland-NH, Netherlands
---------------------------------------------------------------------------
 Ping & Routing Test (Region: GLOBAL)
---------------------------------------------------------------------------
 Network                                 | Details
---------------------------------------------------------------------------
 JP - Tokyo: SoftBank                    | 235ms [No Loss]
 103.214.168.128                         | AS3214 AS1299 AS149042
---------------------------------------------------------------------------
 JP - Tokyo: HE                          | 216ms [No Loss]
 core2.tyo1.he.net                       | AS3214 AS6939
---------------------------------------------------------------------------
 HK - Hong Kong: GCore                   | 192ms [No Loss]
 5.188.230.129                           | AS3214 AS1299 AS199524 AS202422
---------------------------------------------------------------------------
 HK - Hong Kong: LeaseWeb Asia           | 239ms [No Loss]
 43.249.36.49                            | AS3214 AS6830 AS33915 AS2914 AS133752
---------------------------------------------------------------------------
 VN - Ho Chi Minh: FPT Telecom           | 292ms [No Loss]
 103.186.65.98                           | AS3214 AS6461 AS7473 AS18403
---------------------------------------------------------------------------
 SG - Singapore: CDN77                   | 241ms [No Loss]
 89.187.162.1                            | AS3214 AS1299 AS174 AS60068
---------------------------------------------------------------------------
 SG - Singapore: TATA                    | 242ms [No Loss]
 gin-asina-tcore1.as6453.net             | AS3214 AS1299 AS6453
---------------------------------------------------------------------------
 IN - Chennai: Linode                    | 161ms [No Loss]
 speedtest-1.maa1.in.prod.linode.com     | AS3214 AS9498 AS20940 AS63949
---------------------------------------------------------------------------
 IN - Mumbai: Jio                        | 157ms [No Loss]
 49.44.93.128                            | AS3214 AS55836
---------------------------------------------------------------------------
 IR - Tehran: ArvanCloud                 | 89ms [No Loss]
 37.32.0.1                               | AS3214 AS1299 AS6762 AS29049 AS202468
---------------------------------------------------------------------------
 IR - Isfahan: Webdade                   | 110ms [No Loss]
 194.5.50.94                             | AS3214 AS6830 AS3257 AS49556
---------------------------------------------------------------------------
 RU - Moscow: Misaka                     | 49ms [No Loss]
 45.142.246.177                          | AS3214 AS1299 AS9002 AS969 AS57578
---------------------------------------------------------------------------
 RO - Bucharest: M247                    | 41ms [No Loss]
 185.45.12.22                            | AS3214 AS9009
---------------------------------------------------------------------------
 DE - Falkenstein: Hetzner               | 11ms [No Loss]
 fsn1-speed.hetzner.com                  | AS3214 AS24940
---------------------------------------------------------------------------
 FR - Paris: M247                        | 16ms [No Loss]
 185.94.189.162                          | AS3214 AS9009
---------------------------------------------------------------------------
 NL - Amsterdam: Clouvider               | 1ms [No Loss]
 194.127.172.33                          | AS3214 AS62240
---------------------------------------------------------------------------
 UK - London: CDN77                      | 8ms [No Loss]
 185.59.221.51                           | AS3214 AS1299 AS60068
---------------------------------------------------------------------------
 CA - Montreal: OVH                      | 83ms [No Loss]
 51.222.154.207                          | AS3214 AS16276
---------------------------------------------------------------------------
 US - Buffalo: ColoCrossing              | 96ms [No Loss]
 192.3.180.103                           | AS3214 AS1299 AS36352
---------------------------------------------------------------------------
 US - New York: ReliableSite             | 88ms [No Loss]
 104.243.42.233                          | AS3214 AS1299 AS6453 AS23470
---------------------------------------------------------------------------
 US - Miami: ReliableSite                | 110ms [No Loss]
 104.238.204.68                          | AS3214 AS1299 AS6453 AS30058 AS23470
---------------------------------------------------------------------------
 US - Chicago: Psychz Networks           | 91ms [No Loss]
 108.181.140.235                         | AS3214 AS1299 AS3257 AS40676
---------------------------------------------------------------------------
 US - Dallas: GSL                        | 108ms [No Loss]
 216.146.25.35                           | AS3214 AS7578 AS63018
---------------------------------------------------------------------------
 US - Seattle: xTom                      | 135ms [No Loss]
 23.145.48.48                            | AS3214 AS1299 AS23033 AS50131
---------------------------------------------------------------------------
 US - Los Angeles: WebNX                 | 144ms [No Loss]
 64.185.232.162                          | AS3214 AS7578 AS18450
---------------------------------------------------------------------------
---------------------------------------------------------------------------
 Duration           : 6 min 11 sec
 System Time        : 08/07/2025 - 20:28:30 IST
 Total Script Runs  : 117645
---------------------------------------------------------------------------
```

## Sample Output (iperf3)
```
---------------------------------- nws.sh ---------------------------------
      A simple script to bench network performance using speedtest-cli     
---------------------------------------------------------------------------
 Version            : v2026.06.05
 Global Speedtest   : wget -qO- nws.sh | bash
 Region Speedtest   : wget -qO- nws.sh | bash -s -- -r <region>
 iperf3 test        : wget -qO- nws.sh | bash -s -- -iperf
 Ping & Routing     : wget -qO- nws.sh | bash -s -- -rt <region>
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : AMD Ryzen 9 9950X 16-Core Processor
 CPU Cores          : 1 @ 4291.932 MHz
 CPU Cache          : 1024 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 24.6 GB (11.2 GB Used)
 Total RAM          : 1.9 GB (642.9 MB Used)
 System uptime      : 76 days, 19 hour 41 min
 Load average       : 0.14, 0.09, 0.06
 OS                 : Debian GNU/Linux 13
 Arch               : x86_64 (64 Bit)
 Kernel             : 6.12.63+deb13-amd64
 Virtualization     : KVM
 TCP Control        : cubic
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 IPv6 Access        : ✔ Online
 IPv4 Access        : ✔ Online
 ISP                : WebNX, Inc.
 ASN                : AS18450 WebNX, Inc.
 Host               : 365 Group
 Location           : Los Angeles, California-CA, United States
---------------------------------------------------------------------------
 iperf3 (Region: GLOBAL)
---------------------------------------------------------------------------
 Location         Latency     Port    DL Speed       UP Speed       Server

 Network Mode: IPv4

 New York, US     63.7 ms     40G     3470.00 Mbps   2090.00 Mbps   PureVoltage
 Kansas City, US  39.4 ms     200G    4620.00 Mbps   4090.00 Mbps   Nocix
 Los Angeles, US  0.861 ms    10G     9360.00 Mbps   9240.00 Mbps   Leaseweb
 Ashburn, US      52.8 ms     10G     4020.00 Mbps   39.00 Mbps     Fortinet
 Salt Lake, US    15.9 ms     10G     3020.00 Mbps   busy           XMission

 Vienna, AT       148 ms      200G    984.00 Mbps    1390.00 Mbps   Alwyzon
 Frankfurt, DE    153 ms      50G     1340.00 Mbps   1310.00 Mbps   Wobcom
 Paris, FR        148 ms      100G    1310.00 Mbps   1500.00 Mbps   Online.net
 London, UK       --          10G     885.00 Mbps    1000.00 Mbps   Leaseweb
 Amsterdam, NL    133 ms      20G     1550.00 Mbps   950.00 Mbps    Novogara
 Kyiv, UA         179 ms      40G     743.00 Mbps    770.00 Mbps    Cosmonova

 Sydney, AU       135 ms      10G     860.00 Mbps    176.00 Mbps    Leaseweb
 Singapore, SG    189 ms      10G     busy           busy           VSYS-Host
 Mumbai, IN       261 ms      10G     busy           busy           OVH


 Network Mode: IPv6

 Kansas City, US  38.7 ms     200G    5240.00 Mbps   4320.00 Mbps   Nocix
 Los Angeles, US  0.824 ms    10G     9260.00 Mbps   9130.00 Mbps   Leaseweb
 Salt Lake, US    15.9 ms     10G     2900.00 Mbps   9090.00 Mbps   XMission

 Vienna, AT       148 ms      200G    1250.00 Mbps   1360.00 Mbps   Alwyzon
 Frankfurt, DE    153 ms      50G     1260.00 Mbps   1190.00 Mbps   Wobcom
 London, UK       141 ms      10G     1260.00 Mbps   857.00 Mbps    Leaseweb
 Amsterdam, NL    133 ms      20G     1630.00 Mbps   1310.00 Mbps   Novogara

 Sydney, AU       135 ms      10G     820.00 Mbps    136.00 Mbps    Leaseweb
 Mumbai, IN       261 ms      10G     686.00 Mbps    561.00 Mbps    OVH

---------------------------------------------------------------------------
 Avg DL Speed       : 2672.40 Mbps
 Avg UL Speed       : 2525.45 Mbps

 Total DL Data      : 65.77 GB
 Total UL Data      : 59.10 GB
 Total Data         : 124.87 GB
---------------------------------------------------------------------------
 Duration           : 14 min 20 sec
 System Time        : 05/06/2026 - 20:18:24 IST
---------------------------------------------------------------------------
 Result             : https://result.nws.sh/r/1780670904_CFHR9V_GLOBAL.txt
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
