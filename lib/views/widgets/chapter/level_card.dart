import 'package:flutter/material.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/views/screens/home_screen.dart';

class LevelCard extends StatelessWidget {
  final String level;
  final int refIdLevel;
  final bool isCompleted;
  final bool isAble;

  LevelCard({
    Key? key,
    required this.level,
    required this.refIdLevel,
    required this.isCompleted,
    required this.isAble,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isAble && !isCompleted) ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: "Lele"),
          ),
        );
      } : null,
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.brown.shade800,
                  width: 3,
                ),
              ),
              child: Center(
                child: isAble ? Text(
                  level,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ) : Padding(padding: EdgeInsetsGeometry.all(8.0), child: Image(image: AssetImage(pathImg("locker.png")))),
              ),
            ),
            
            Positioned(
              top: -1,
              right: -1,
              child: Container(
                decoration: BoxDecoration(
                  color:  Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.brown.shade800,
                    width: 3,
                  ),
                ),
                padding: EdgeInsets.all(4),
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle_outlined,
                  color: isCompleted ? Colors.green.shade700 : Colors.orange,
                  size: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}