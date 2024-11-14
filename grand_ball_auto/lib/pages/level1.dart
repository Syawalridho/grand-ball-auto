import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MazePuzzle extends StatefulWidget {
  const MazePuzzle({super.key});

  @override
  State<MazePuzzle> createState() => _MazePuzzleState();
}

class _MazePuzzleState extends State<MazePuzzle> {
  static int numberInRow = 36;
  int numberOfSquares = numberInRow * 51;

  List<int> barriers = [
    // Baris Atas
    0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,

    // Pinggir Kiri
    36, 72, 108, 144, 180, 216, 252, 288, 324, 360, 396, 432, 468, 504, 540, 576, 612, 648, 684, 720, 756, 792, 828, 864, 900, 936, 972, 1008, 1044,
    1080, 1116, 1152, 1188, 1224, 1260, 1296, 1332, 1368, 1404, 1440, 1476, 1512, 1548, 1584, 1620, 1656, 1692, 1728, 1764, 1800,

    // Baris Bawah
    1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1810, 1811, 1812, 1813, 1814, 1815, 1816, 1817, 1818, 1819, 1820, 1821, 1822,
    1823, 1824, 1825, 1826, 1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834,

    // Pinggir Kanan
    71, 107, 143, 179, 215, 251, 287, 323, 359, 395, 431, 467, 503, 539, 575, 611, 647, 683, 719, 755, 791, 827, 863, 899,
    935, 971, 1007, 1043, 1079, 1115, 1151, 1187, 1223, 1259, 1295, 1331, 1367, 1403, 1439, 1475, 1511, 1547, 1583, 1619, 1655,
    1691, 1727, 1763, 1799, 1835,

    //Maze
    41, 77, 113, 149, 185,

    51, 87, 123, 159, 195, 194, 193, 192, 191, 190, 226, 262, 298, 334, 370, 406, 442, 478, 514, 550,
    551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565,
    601, 637, 673, 709, 745, 781, 817, 673, 709, 745, 781, 817, 853, 889, 925,
    591, 627, 663, 699, 735, 736, 737, 738, 739, 740, 776, 812, 848, 884, 920,
    524, 488, 452, 416, 380, 344, 308, 272, 236, 200,
    375, 376, 377, 378, 379, 

    541, 542, 543, 544, 545, 365, 401, 437, 473, 509, 581, 617, 653, 689, 725, 726, 727, 728, 729, 730,

    390, 391, 392, 393, 394,

    66, 102, 138, 174, 210, 209, 208, 207, 206, 205, 241, 277, 313, 349, 385,

    570, 606, 642, 678, 714, 750, 786, 822, 858, 894, 930, 966, 1002, 1038, 1074, 1110, 1105, 1106, 1107, 1108, 1109, 1111, 1112, 1113, 1114,

    915, 914, 913, 912, 911, 910, 909, 908, 907, 906, 905, 941, 977, 1013, 1049, 1085, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100,
    1136, 1172, 1208, 1244, 1280, 1316, 1352, 1388, 1424, 1460, 1496, 1532, 1568, 1604, 1640,

    1769, 1733, 1697, 1661, 1625, 1589, 1553, 1517, 1481, 1445, 1409, 1373, 1337, 1301, 1265, 1266, 1267, 1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275,
    1311, 1347, 1383, 1419, 1455, 1491, 1527, 1563, 1599, 1635, 1634, 1633, 1632, 1631, 1630,
    1594, 1558, 1522, 1486, 1450,

    1470, 1434, 1398, 1362, 1326, 1290, 1289, 1288, 1287, 1286, 1285, 1321, 1357, 1357, 1393, 1429, 1465, 1501, 1537, 1573, 1609, 1645,
    1646, 1647, 1648, 1649, 1650, 1651, 1652, 1653, 1653, 1654,
  ];
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: numberOfSquares,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numberInRow,
          mainAxisSpacing: 0, // Remove vertical gap
          crossAxisSpacing: 0, // Remove horizontal gap
          childAspectRatio: 1.0, // Set the aspect ratio to 1:1
        ),
        itemBuilder: (BuildContext context, int index) {
          if (barriers.contains(index)) {
            return Container(
              color: Colors.blue,
            );
          } else {
            return Container(
              color: Colors.grey,
            );
          }
        },
      ),
    );
  }
}

class Level1Widget extends StatefulWidget {
  const Level1Widget({super.key});

  @override
  State<Level1Widget> createState() => _Level1WidgetState();
}

class _Level1WidgetState extends State<Level1Widget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String _timerValue = "00:00";

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((time) {
      final displayTime = StopWatchTimer.getDisplayTime(time, hours: false, milliSecond: false);
      setState(() {
        _timerValue = displayTime;
      });
    });
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.12,
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      'lib/assets/images/BackgroundFull.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Text(
                    _timerValue,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 53,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Container(
                    width: 154,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'LEVEL 1',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Color.fromARGB(255, 109, 109, 109), size: 40),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Color.fromARGB(255, 109, 109, 109), size: 40),
                      SizedBox(width: 10),
                      Icon(Icons.star, color: Color.fromARGB(255, 109, 109, 109), size: 40),
                    ],
                  ),
                ),
              ),
              // Adjusted padding for the maze with specified top, bottom, left, and right paddings
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,    // 120px top padding  // 70px bottom padding
                  left: 40,    // 60px left padding
                  right: 40,   // 60px right padding
                ),
                child: MazePuzzle(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.menu_rounded, color: Colors.white, size: 32),
                    onPressed: () {
                      print('Menu Icon Button pressed');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

