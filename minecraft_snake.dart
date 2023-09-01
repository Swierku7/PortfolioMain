import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(SnakeGameApp());

class SnakeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minecraft Snake',
      theme: ThemeData.dark(),
      home: CharacterSelectionScreen(),
    );
  }
}

enum CharacterType {
  Steve,
  Alex,
  Zombie,
  Enderman,
}

class CharacterSelectionScreen extends StatefulWidget {
  @override
  _CharacterSelectionScreenState createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  CharacterType selectedCharacter = CharacterType.Steve;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybierz Postać'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCharacterButton(CharacterType.Steve),
            _buildCharacterButton(CharacterType.Alex),
            _buildCharacterButton(CharacterType.Zombie),
            _buildCharacterButton(CharacterType.Enderman),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SnakeGame(selectedCharacter),
                  ),
                );
              },
              child: Text('Rozpocznij Grę'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterButton(CharacterType characterType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCharacter = characterType;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        color: selectedCharacter == characterType
            ? Colors.blue
            : Colors.transparent,
        child: Image.asset(
          _getCharacterImage(characterType),
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  String _getCharacterImage(CharacterType characterType) {
    switch (characterType) {
      case CharacterType.Steve:
        return 'assets/steve.png';
      case CharacterType.Alex:
        return 'assets/alex.png';
      case CharacterType.Zombie:
        return 'assets/zombie.png';
      case CharacterType.Enderman:
        return 'assets/enderman.png';
      default:
        return '';
    }
  }
}

class SnakeGame extends StatefulWidget {
  final CharacterType selectedCharacter;

  SnakeGame(this.selectedCharacter);

  @override
  _SnakeGameState createState() => _SnakeGameState(selectedCharacter);
}

class _SnakeGameState extends State<SnakeGame> {
  CharacterType selectedCharacter;

  _SnakeGameState(this.selectedCharacter);

  List<Offset> snake = [Offset(5, 5)];
  Offset food = Offset(10, 10);
  Offset powerUpPosition = Offset(-1, -1);
  int powerUpType = 0;
  Offset direction = Offset(1, 0);
  int score = 0;
  double cellSize = 20.0;
  double initialSnakeSpeed = 500;
  double snakeSpeed = 500;
  int level = 1;
  bool glowingSnake = false;
  bool isGamePaused = false;
  IconData pauseIcon = Icons.pause;

  late Timer snakeTimer;
  late Timer _powerUpTimer;

  void startSnakeTimer() {
    snakeTimer = Timer.periodic(Duration(milliseconds: snakeSpeed.toInt() ~/ 2), (timer) {
      _updateSnake();
    });
  }

  void stopSnakeTimer() {
    snakeTimer.cancel();
    _powerUpTimer.cancel();
  }

  void _generateFood() {
    food = Offset(
      Random().nextInt(20).toDouble(),
      Random().nextInt(20).toDouble(),
    );
  }

  void _generatePowerUp() {
    powerUpType = Random().nextInt(2) + 1;
    powerUpPosition = Offset(
      Random().nextInt(20).toDouble(),
      Random().nextInt(20).toDouble(),
    );
  }

  void _growSnake() {
    snake.insert(0, snake.first);
  }

  void _startPowerUpTimer() {
    _powerUpTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      _generatePowerUp();
    });
  }

  @override
  void initState() {
    super.initState();
    startSnakeTimer();
    _generateFood();
    _startPowerUpTimer();
  }

  @override
  void dispose() {
    stopSnakeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minecraft Snake'),
        actions: [
          IconButton(
            icon: Icon(pauseIcon),
            onPressed: () {
              setState(() {
                if (isGamePaused) {
                  startSnakeTimer();
                  pauseIcon = Icons.pause;
                } else {
                  stopSnakeTimer();
                  pauseIcon = Icons.play_arrow;
                }
                isGamePaused = !isGamePaused;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 2.0),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                final dx = details.delta.dx;
                final dy = details.delta.dy;

                if (dx.abs() > dy.abs()) {
                  if (dx > 20) {
                    if (direction.dx == 0) {
                      direction = Offset(1, 0);
                    }
                  } else if (dx < -20) {
                    if (direction.dx == 0) {
                      direction = Offset(-1, 0);
                    }
                  }
                } else {
                  if (dy > 20) {
                    if (direction.dy == 0) {
                      direction = Offset(0, 1);
                    }
                  } else if (dy < -20) {
                    if (direction.dy == 0) {
                      direction = Offset(0, -1);
                    }
                  }
                }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 20,
                ),
                itemBuilder: (context, index) {
                  Offset position = Offset((index % 20).toDouble(), (index ~/ 20).toDouble());
                  if (snake.contains(position)) {
                    return _buildSnakeCell();
                  } else if (position == food) {
                    return _buildFoodCell();
                  } else if (position == powerUpPosition) {
                    return _buildPowerUpCell();
                  } else {
                    return _buildEmptyCell();
                  }
                },
              ),
            ),
          ),
          if (glowingSnake)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedContainer(
                  color: Colors.purple.withOpacity(0.5),
                  duration: Duration(milliseconds: 500),
                ),
              ),
            ),
          Positioned(
            left: snake.first.dx * cellSize,
            top: snake.first.dy * cellSize,
            child: Image.asset(
              _getCharacterImage(selectedCharacter),
              width: cellSize,
              height: cellSize,
            ),
          ),
        ],
      ),
    );
  }

  void _updateSnake() {
    final newHead = snake.first + direction;

    final newHeadX = (newHead.dx + 20) % 20;
    final newHeadY = (newHead.dy + 20) % 20;
    final newHeadPosition = Offset(newHeadX, newHeadY);

    setState(() {
      if (_checkCollision(newHeadPosition)) {
        _endGame();
        return;
      }

      snake.insert(0, newHeadPosition);

      if (newHeadPosition == food) {
        _generateFood();
        score++;
        _growSnake();
      } else if (newHeadPosition == powerUpPosition) {
        _applyPowerUp();
      } else {
        snake.removeLast();
      }
    });
  }

  bool _checkCollision(Offset position) {
    return snake.contains(position);
  }

  void _endGame() {
    stopSnakeTimer();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You ate $score cells'),
          actions: <Widget>[
            TextButton(
              child: Text('Zagraj Ponownie'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CharacterSelectionScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _getCharacterImage(CharacterType characterType) {
    switch (characterType) {
      case CharacterType.Steve:
        return 'assets/steve.png';
      case CharacterType.Alex:
        return 'assets/alex.png';
      case CharacterType.Zombie:
        return 'assets/zombie.png';
      case CharacterType.Enderman:
        return 'assets/enderman.png';
      default:
        return '';
    }
  }

  Widget _buildSnakeCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildFoodCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildPowerUpCell() {
    String iconPath = powerUpType == 1 ? 'assets/enchantedbook.png' : 'assets/enchantedapple.png';
    Color iconColor = powerUpType == 1 ? Colors.blue : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: iconColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Image.asset(iconPath),
    );
  }

  Widget _buildEmptyCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  void _applyPowerUp() {
    if (powerUpType == 1) {
      setState(() {
        glowingSnake = true;
        snakeSpeed = initialSnakeSpeed * 0.5;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          glowingSnake = false;
          snakeSpeed = initialSnakeSpeed;
        });
      });
    } else if (powerUpType == 2) {
      if (snake.length > 2) {
        snake.removeRange(snake.length - 2, snake.length);
      }
    }

    powerUpType = 0;
    powerUpPosition = Offset(-1, -1);
  }
}
