import 'package:flutter/material.dart';
import 'package:whisky_app/models/whisky_entry.dart';
import 'dart:math';

class AddEntryScreen extends StatefulWidget {
  final Function(WhiskyEntry) addEntry;

  AddEntryScreen({required this.addEntry});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj nową pozycję'),
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
              // ... pozostałe pola
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveEntry,
                child: Text('Zapisz nową pozycję'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final newEntry = WhiskyEntry(
        key: null,
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
      );

      widget.addEntry(newEntry);

      Navigator.of(context).pop();
    }
  }
}
