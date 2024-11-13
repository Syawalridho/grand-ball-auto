import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Level1Widget extends StatefulWidget {
  const Level1Widget({super.key});

  @override
  State<Level1Widget> createState() => _Level1WidgetState();
}

class _Level1WidgetState extends State<Level1Widget> {
  // StopWatchTimer controller
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String _timerValue = "00:00";
  
  @override
  void initState() {
    super.initState();
    // Listen to the rawTime stream to update the display
    _stopWatchTimer.rawTime.listen((time) {
      final displayTime = StopWatchTimer.getDisplayTime(time, hours: false, milliSecond: false);
      setState(() {
        _timerValue = displayTime;
      });
    });
    // Start the timer immediately when the widget is initialized
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose(); // Dispose of the timer when widget is destroyed
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
              // Background dengan opacity 0.5
              Opacity(
                opacity: 0.12,  // Set opacity 0.5
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      'lib/assets/images/BackgroundFull.png',
                      width: double.infinity,  // Menyesuaikan lebar layar
                      height: double.infinity, // Menyesuaikan tinggi layar
                      fit: BoxFit.cover, // Gambar akan menutupi seluruh layar
                    ),
                  ),
                ),
              ),
              
              // Timer Display
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
              
              // Level Name Display
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
                alignment: Alignment.topCenter, // Agar berada di tengah secara horizontal
                child: Padding(
                  padding: const EdgeInsets.only(top: 140), // Jarak 20px setelah LEVEL 1
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Menempatkan bintang di tengah secara horizontal
                    crossAxisAlignment: CrossAxisAlignment.center, // Menjaga bintang tetap di tengah secara vertikal
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color.fromARGB(255, 109, 109, 109),
                        size: 40,
                      ),
                      SizedBox(width: 10), // Mengatur jarak antara bintang pertama dan kedua
                      Icon(
                        Icons.star,
                        color: const Color.fromARGB(255, 109, 109, 109),
                        size: 40,
                      ),
                      SizedBox(width: 10), // Mengatur jarak antara bintang kedua dan ketiga
                      Icon(
                        Icons.star,
                        color: const Color.fromARGB(255, 109, 109, 109),
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Icon Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
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
