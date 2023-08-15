import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimalMedicineScreen(),
    );
  }
}

class AnimalMedicineScreen extends StatefulWidget {
  @override
  _AnimalMedicineScreenState createState() => _AnimalMedicineScreenState();
}

class _AnimalMedicineScreenState extends State<AnimalMedicineScreen> {
  String _selectedAnimal = 'Kot';
  String _selectedMedicine = 'Furosemid';
  TextEditingController _weightController = TextEditingController();
  double _calculatedDose = 0;

  Map<String, Map<String, double>> doses = {
    'Kot': {
      'Furosemid': 1,
      'Cardisure': 3,
      'Cardiovet': 5,
    },
    'Pies': {
      'Furosemid': 2,
      'Cardisure': 6,
      'Cardiovet': 10,
    },
  };

  void _calculateDose() {
    double weight = _parseWeight(_weightController.text);
    double dose = doses[_selectedAnimal]?.containsKey(_selectedMedicine) ?? false
        ? doses[_selectedAnimal]![_selectedMedicine]!
        : 0;
    setState(() {
      _calculatedDose = weight * dose;
    });

    // Schowanie klawiatury po naciśnięciu przycisku "Oblicz"
    FocusScope.of(context).unfocus();
  }

  double _parseWeight(String text) {
   
    String normalizedText = text.replaceAll(',', '.');


    return double.tryParse(normalizedText) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator Dawki Leku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 36,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'iVETapp',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedAnimal,
              items: ['Kot', 'Pies']
                  .map((animal) => DropdownMenuItem(
                value: animal,
                child: Row(
                  children: [
                    Icon(
                      animal == 'Kot'
                          ? LineIcons.cat // Ikona dla Kota
                          : LineIcons.dog, // Ikona dla Psa
                    ),
                    SizedBox(width: 10),
                    Text(animal),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAnimal = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Wybierz gatunek zwierzęcia',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMedicine,
              items: ['Furosemid', 'Cardisure', 'Cardiovet']
                  .map((medicine) => DropdownMenuItem(
                value: medicine,
                child: Text(medicine),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMedicine = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Wybierz lek',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Waga zwierzęcia (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateDose,
              child: Text('Oblicz'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Obliczona dawka leku:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            '$_calculatedDose mg',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
