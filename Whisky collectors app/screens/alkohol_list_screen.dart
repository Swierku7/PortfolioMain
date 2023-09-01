import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky_entry.dart';
import 'package:whisky_app/screens/edit_entry_screen.dart';
import 'package:hive/hive.dart';
import 'package:whisky_app/screens/home_screen.dart'; // Dodaj import

class AlkoholListScreen extends StatefulWidget {
  final Box<WhiskyEntry> whiskyBox;
  final GlobalKey<HomeScreenState> homeScreenKey; // Dodaj to pole

  AlkoholListScreen({required this.whiskyBox, required this.homeScreenKey}); // Dodaj homeScreenKey do konstruktora

  @override
  _AlkoholListScreenState createState() => _AlkoholListScreenState();
}

class _AlkoholListScreenState extends State<AlkoholListScreen> {
  List<WhiskyEntry> _whiskyList = [];

  @override
  void initState() {
    super.initState();
    _updateWhiskyList();
  }

  void _updateWhiskyList() async {
    setState(() {
      _whiskyList = widget.whiskyBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista alkoholi'),
      ),
      body: ListView.builder(
        itemCount: _whiskyList.length,
        itemBuilder: (context, index) {
          final whisky = _whiskyList[index];
          return Dismissible(
            key: Key(whisky.key.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            onDismissed: (_) => _deleteWhisky(context, whisky),
            child: ListTile(
              title: Text(whisky.nazwaBottlingu),
              subtitle: Text(whisky.destylarnia ?? ''),
              onTap: () => _editEntry(context, whisky),
              trailing: GestureDetector(
                onTap: () => _deleteWhisky(context, whisky),
                child: Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }

  void _editEntry(BuildContext context, WhiskyEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditEntryScreen(
              entry: entry,
              whiskyBox: widget.whiskyBox,
              whiskyList: _whiskyList,
              onDelete: (deletedEntry) {
                setState(() {
                  _whiskyList.removeWhere((whisky) =>
                  whisky.key == deletedEntry.key);
                });
              },
              homeScreenKey: widget.homeScreenKey,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _whiskyList.removeWhere((whisky) => whisky.key == entry.key);
      });
    }
  }

  void _deleteWhisky(BuildContext context, WhiskyEntry entry) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usuwanie pozycji'),
          content: Text('Czy na pewno chcesz usunąć tę pozycję?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Zamknij alert dialog
              },
              child: Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                await widget.whiskyBox.delete(entry.key); // Usuń z bazy danych

                setState(() {
                  _whiskyList.removeWhere((whisky) => whisky.key == entry.key); // Usuń z listy
                });

                Navigator.of(context).pop(); // Zamknij alert dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Usunięto wpis: ${entry.nazwaBottlingu}'),
                  ),
                );

                // Odsunięcie odświeżania listy do następnego cyklu build
                Future.delayed(Duration.zero, () {
                  _updateWhiskyList();
                });
              },
              child: Text('Usuń'),
            ),
          ],
        );
      },
    );
  }
}
