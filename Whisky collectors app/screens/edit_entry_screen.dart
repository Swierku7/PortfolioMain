import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky_entry.dart';
import 'package:hive/hive.dart';
import 'package:whisky_app/screens/home_screen.dart';

class EditEntryScreen extends StatefulWidget {
  final WhiskyEntry entry;
  final Box<WhiskyEntry> whiskyBox;
  final List<WhiskyEntry> whiskyList;
  final Function(WhiskyEntry) onDelete;
  final GlobalKey<HomeScreenState> homeScreenKey;

  EditEntryScreen({
    required this.entry,
    required this.whiskyBox,
    required this.whiskyList,
    required this.onDelete,
    required this.homeScreenKey,
  });

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nazwaController = TextEditingController();
  final _destylarniaController = TextEditingController();
  final _rokDestylacjiController = TextEditingController();
  final _rokButelkowaniaController = TextEditingController();
  final _rodzajBeczekController = TextEditingController();
  final _zawartoscAlkoholuController = TextEditingController();
  bool _niefiltrowana = false;
  bool _bezBarwienia = false;
  final _kolorController = TextEditingController();
  final _aromatController = TextEditingController();
  final _smakController = TextEditingController();
  final _finiszController = TextEditingController();
  final _ocenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nazwaController.text = widget.entry.nazwaBottlingu ?? '';
    _destylarniaController.text = widget.entry.destylarnia ?? '';
    _rokDestylacjiController.text = widget.entry.rokDestylacji?.toString() ?? '';
    _rokButelkowaniaController.text =
        widget.entry.rokButelkowania?.toString() ?? '';
    _rodzajBeczekController.text = widget.entry.rodzajBeczek ?? '';
    _zawartoscAlkoholuController.text = widget.entry.zawartoscAlkoholu ?? '';
    _niefiltrowana = widget.entry.niefiltrowana ?? false;
    _bezBarwienia = widget.entry.bezBarwienia ?? false;
    _kolorController.text = widget.entry.kolor ?? '';
    _aromatController.text = widget.entry.aromat ?? '';
    _smakController.text = widget.entry.smak ?? '';
    _finiszController.text = widget.entry.finisz ?? '';
    _ocenaController.text = widget.entry.ocena?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytuj pozycję'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nazwaController,
                decoration: InputDecoration(labelText: 'Nazwa Bottlingu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pole nie może być puste';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destylarniaController,
                decoration: InputDecoration(labelText: 'Destylarnia'),
              ),
              TextFormField(
                controller: _rokDestylacjiController,
                decoration: InputDecoration(labelText: 'Rok destylacji'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Wprowadź poprawny rok';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rokButelkowaniaController,
                decoration: InputDecoration(labelText: 'Rok butelkowania'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Wprowadź poprawny rok';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rodzajBeczekController,
                decoration: InputDecoration(labelText: 'Rodzaj beczek'),
              ),
              TextFormField(
                controller: _zawartoscAlkoholuController,
                decoration: InputDecoration(labelText: 'Zawartość alkoholu'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Wprowadź poprawną zawartość alkoholu';
                    }
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Niefiltrowana'),
                value: _niefiltrowana,
                onChanged: (value) {
                  setState(() {
                    _niefiltrowana = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Bez barwienia'),
                value: _bezBarwienia,
                onChanged: (value) {
                  setState(() {
                    _bezBarwienia = value ?? false;
                  });
                },
              ),
              TextFormField(
                controller: _kolorController,
                decoration: InputDecoration(labelText: 'Kolor'),
              ),
              TextFormField(
                controller: _aromatController,
                decoration: InputDecoration(labelText: 'Aromat'),
              ),
              TextFormField(
                controller: _smakController,
                decoration: InputDecoration(labelText: 'Smak'),
              ),
              TextFormField(
                controller: _finiszController,
                decoration: InputDecoration(labelText: 'Finisz'),
              ),
              TextFormField(
                controller: _ocenaController,
                decoration: InputDecoration(labelText: 'Ocena'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Wprowadź poprawną ocenę';
                    }
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _deleteEntry,
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text('Usuń wpis'),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: Text('Zapisz zmiany'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteEntry() {
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
              onPressed: () {
                _deleteWhiskyEntry();
                Navigator.of(context).pop(); // Zamknij alert dialog
              },
              child: Text('Usuń'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWhiskyEntry() async {
    final key = widget.entry.key;
    await widget.whiskyBox.delete(key);

    // Usuń wpis z listy whiskyList
    widget.whiskyList.removeWhere((whisky) => whisky.key == key);

    // Wywołaj funkcję onDelete, przekazując usuwany wpis
    widget.onDelete(widget.entry);

    // Zamknij aktualny ekran i wróć do poprzedniego ekranu
    Navigator.of(context).pop();

    // Aktualizuj listę alkoholi w poprzednim ekranie (HomeScreen)
    _updateWhiskyList();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedEntry = WhiskyEntry(
        nazwaBottlingu: _nazwaController.text,
        destylarnia: _destylarniaController.text,
        rokDestylacji: int.tryParse(_rokDestylacjiController.text) ?? 0,
        rokButelkowania: int.tryParse(_rokButelkowaniaController.text) ?? 0,
        rodzajBeczek: _rodzajBeczekController.text,
        zawartoscAlkoholu: _zawartoscAlkoholuController.text,
        niefiltrowana: _niefiltrowana,
        bezBarwienia: _bezBarwienia,
        kolor: _kolorController.text,
        aromat: _aromatController.text,
        smak: _smakController.text,
        finisz: _finiszController.text,
        ocena: int.tryParse(_ocenaController.text) ?? 0,
        key: widget.entry.key,
      );
      final oldKey = widget.entry.key;
      widget.whiskyBox.delete(oldKey);

      setState(() {
        widget.whiskyList.removeWhere((whisky) => whisky.key == oldKey);
      });

      widget.whiskyBox.put(updatedEntry.key, updatedEntry); // Zaktualizuj klucz na nowy klucz
      final index =
      widget.whiskyList.indexWhere((whisky) => whisky.key == updatedEntry.key);
      if (index != -1) {
        setState(() {
          widget.whiskyList[index] = updatedEntry;
        });
      }
      Navigator.of(context).pop(updatedEntry);
    }
  }

  void _updateWhiskyList() {
    setState(() {
      widget.whiskyList.clear();
      widget.whiskyList.addAll(widget.whiskyBox.values.toList());
    });
  }
}
