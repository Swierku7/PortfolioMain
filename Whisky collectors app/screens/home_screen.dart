import 'package:flutter/material.dart';
import 'package:whisky_app/screens/add_entry_screen.dart';
import 'package:whisky_app/screens/alkohol_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whisky_app/models/whisky_entry.dart';

class HomeScreen extends StatefulWidget {
  final Box<WhiskyEntry> whiskyBox;
  final GlobalKey<HomeScreenState> homeScreenKey;

  HomeScreen({required this.whiskyBox, required this.homeScreenKey});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void updateWhiskyList() {
    setState(() {
      // Opcjonalna aktualizacja stanu ekranu HomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhiskyApp by WhiskyClub'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ikona.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        AddEntryScreen(addEntry: _addEntry)),
                  );
                },
                child: Text('Dodaj nową pozycję'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        AlkoholListScreen(whiskyBox: widget.whiskyBox, homeScreenKey: widget.homeScreenKey)),
                  );
                },
                child: Text('Lista alkoholi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEntry(WhiskyEntry entry) async {
    await widget.whiskyBox.add(entry);
    widget.homeScreenKey.currentState?.updateWhiskyList();
  }
}
