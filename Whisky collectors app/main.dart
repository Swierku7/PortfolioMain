import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whisky_app/models/whisky_entry.dart';
import 'package:whisky_app/screens/home_screen.dart';
import 'package:whisky_app/screens/add_entry_screen.dart';
import 'package:whisky_app/screens/alkohol_list_screen.dart';
import 'package:whisky_app/screens/edit_entry_screen.dart';
import 'package:whisky_app/models/whisky_entry_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WhiskyEntryAdapter());
  await Hive.openBox<WhiskyEntry>('whiskyBox');

  runApp(HiveListener(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Box<WhiskyEntry> whiskyBox = Hive.box<WhiskyEntry>('whiskyBox');
  final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhiskyApp by WhiskyClub',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      home: HomeScreen(whiskyBox: whiskyBox, homeScreenKey: homeScreenKey),
      initialRoute: '/',
      routes: {
        '/addEntry': (context) => AddEntryScreen(addEntry: _addEntry),
        '/alkoholList': (context) => AlkoholListScreen(whiskyBox: whiskyBox, homeScreenKey: homeScreenKey),
        '/editEntry': (context) => EditEntryScreen(
          entry: WhiskyEntry(
            key: '',
            nazwaBottlingu: '',
            bezBarwienia: false,
            niefiltrowana: false,
            ocena: 0,
          ),
          whiskyBox: whiskyBox,
          whiskyList: [],
          onDelete: (deletedEntry) {
            _updateWhiskyList();
          },
          homeScreenKey: homeScreenKey,
        ),
      },
    );
  }

  void _addEntry(WhiskyEntry entry) async {
    await whiskyBox.add(entry);
    _updateWhiskyList();
  }

  void _updateWhiskyList() {
    homeScreenKey.currentState?.updateWhiskyList();
  }
}

class HiveListener extends StatefulWidget {
  final Widget child;

  HiveListener({required this.child});

  @override
  _HiveListenerState createState() => _HiveListenerState();
}

class _HiveListenerState extends State<HiveListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    Hive.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.resumed) {
      Hive.box<WhiskyEntry>('whiskyBox').compact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
