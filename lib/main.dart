import 'package:contact_sync/contact_model.dart';
import 'package:flutter/material.dart';
import 'contact_utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Contact Sync Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Box localContactsBox;
  bool localContactsBoxInitialized = false;
  final String customerHash = 'WMSSPSKGYSFJ';

  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(LocalContactAdapter());
    _openBox();
  }

  void _openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    localContactsBox = await Hive.openBox('localContactBox');
    setState(() {
      localContactsBoxInitialized = true;
    });
    print('Box opened');
  }


  Future<void> _updateBox() async {
    setState(() {
      localContactsBoxInitialized = false;
    });
    // await updateBox(localContactsBox);
    await sync(localContactsBox, customerHash);
    setState((){
      localContactsBoxInitialized = true;
      //sync(localContactsBox, customerHash);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: (localContactsBoxInitialized == true)
                  ? contactsScroll(getContactsFromBox(localContactsBox))
                  : [Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.teal,
                  ),
                ),
              )],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateBox,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}


// body: Column(
// children: [
// Expanded(
// child: ListView(
// shrinkWrap: true,
// children: (localContactsBoxInitialized == true && localContactsBoxUpdated == true)
// ? contactsScroll(getContactsFromBox(localContactsBox))
// : [Container(
// color: Colors.white,
// child: const Center(
// child: CircularProgressIndicator(
// backgroundColor: Colors.teal,
// ),
// ),
// )],
// ),
// ),
// ],
// ),