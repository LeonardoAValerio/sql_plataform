import 'package:flutter/material.dart';
import 'package:sql_plataform/core/theme/app_colors.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/views/screens/level/level_screen.dart';

class LevelCard extends StatelessWidget {
  final String level;
  final int refIdLevel;
  final bool isCompleted;
  final bool isAble;
  final VoidCallback? onLevelCompleted; // ← NOVO

  LevelCard({
    Key? key,
    required this.level,
    required this.refIdLevel,
    required this.isCompleted,
    required this.isAble,
    this.onLevelCompleted, // ← NOVO
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAble 
          ? () async { // ← Mudou para async
              await Navigator.push( // ← Mudou para await
                context,
                MaterialPageRoute(
                  builder: (context) => LevelScreen(refId: refIdLevel),
                ),
              );
              
              // Quando voltar, chama o callback para recarregar
              onLevelCompleted?.call(); // ← NOVO
            } 
          : null,
      child: SizedBox(
        width: double.infinity,
        height: 96,
        child: Container(
          decoration: BoxDecoration(
            color: isAble ? AppColors.lightBrown : AppColors.mediumBrown,
            borderRadius: BorderRadius.circular(24),
            border: Border(
              top: BorderSide(
                color: AppColors.darkBrown,
                width: 4.0
              ),
              right: BorderSide(
                color: AppColors.darkBrown,
                width: 4.0
              ),
              left: BorderSide(
                color: AppColors.darkBrown,
                width: 4.0
              ),
              bottom: BorderSide(
                color: AppColors.darkBrown,
                width: 8.0
              ),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: isAble 
                      ? Text(
                          level,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: Offset(3, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Image(
                            image: AssetImage(pathImg("locker.png")),
                            width: 40,
                            height: 40,
                          ),
                        ),
                  ),
                ),
                
                if (isAble) 
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBrown,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.darkBrown,
                        width: 3,
                      ),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle_outlined,
                      color: isCompleted ? AppColors.darkBrown : AppColors.lightBrown,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}