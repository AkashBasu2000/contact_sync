import 'package:contact_sync/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'contact_fetch.dart';
import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final Database databaseHelper = Database();
  ContactFetch contactFetchHelper = ContactFetch();

  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(LocalContactAdapter());
    contactFetchHelper.openBox().then((value){
      setState(() {
        localContactsBoxInitialized = true;
        localContactsBox = value;
      });
    });

  }




  Future<void> _updateBox() async {
    setState(() {
      localContactsBoxInitialized = false;
    });
    // await updateBox(localContactsBox);
    await databaseHelper.sync(localContactsBox, customerHash);
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
                  ? databaseHelper.contactsScroll(databaseHelper.getContactsFromBox(localContactsBox))
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