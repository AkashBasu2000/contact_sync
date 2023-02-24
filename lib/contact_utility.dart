import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'contact_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


Future<PermissionStatus> _getContactPermissions() async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    return permissionStatus;
  }
  return permission;
}

Future<List<LocalContact>> getContactsList() async {
  List<LocalContact> contacts = [];

  final PermissionStatus permissionStatus = await _getContactPermissions();
  if (permissionStatus == PermissionStatus.granted){
    List<Contact> contactList = await ContactsService.getContacts();
    //print('contacts length-> ${contactList.length}');
    var cnt = 0;
    for (Contact contact in contactList){
      contacts.add(
        LocalContact(
            name: contact.displayName,
            photoUri: '',
            customerHash: '',
            mobile: contact.phones?.first.value,
            vpa: '',
            upiNumber8: '',
            upiNumber9: '',
            upiNumber: '',
            isBlocked: false,
            isRegistered: false,
            isSynced: false,
            action: '')
      );
      cnt += 1;
      print('${contact.displayName} - ${contact.phones?.first.value} cnt->$cnt' );
    }
  }

  return contacts;
}

List<Text> contactsScroll(List<LocalContact> contacts){
  if (contacts == Null){
    return [];
  }
  List<Text> scroll = [];
  var nullCount = 0;
  for (LocalContact contactName in contacts){
    if (contactName == Null){
      nullCount += 1;
    }
    else{
      scroll.add(Text('${contactName.name} - ${contactName.mobile}'));
    }
  }
  print('nullCount --> $nullCount');
  return scroll;
}

Future<void> updateBox(Box localContactsBox) async {
  List<LocalContact> contacts = await getContactsList();
  localContactsBox.deleteAll(localContactsBox.keys);
  for (LocalContact contact in contacts){
    localContactsBox.put(hashNumber(contact.mobile!), contact);
    print('mobile : ${contact.mobile}');
  }
  print('Box Updated');
}

List<LocalContact> getContactsFromBox(Box localContactsBox){
  Map<dynamic, dynamic> raw = localContactsBox.toMap();
  print('getting contacts from Box');
  for (String key in localContactsBox.keys){
    print('key: $key value: ${localContactsBox.get(key)}');
  }
  List<LocalContact> list = List<LocalContact>.from(raw.values.toList());// raw.values.toList() as List<LocalContact>;
  return list;
}


String hashNumber(String number){
  // TODO: write hash logic
  return number;
}

Future<String> getBoxDelta(Box localContactsBox) async {
  List<String> add = [];
  List<String> del = [];
  List<LocalContact> contacts = await getContactsList();

  for (String key in localContactsBox.keys) {
    LocalContact contact = localContactsBox.get(key);
    contact.isSynced = false;
    localContactsBox.put(key, contact);
  }

  for (LocalContact contact in contacts){
    String key = hashNumber(contact.mobile!);
    if (localContactsBox.containsKey(key)){
      LocalContact contact = localContactsBox.get(key);
      contact.isSynced = true;
      // TODO: add logic to update name if required
      localContactsBox.put(key, contact);
    }
    else{
      add.add(key);
      contact.isSynced = false;
      contact.action = 'added';
      localContactsBox.put(key,contact);
    }
  }

  for (String key in localContactsBox.keys) {
    LocalContact contact = localContactsBox.get(key);
    if (contact.isSynced==false && contact.action==''){
      del.add(key);
      contact.action = 'delete';
    }
    localContactsBox.put(key, contact);
  }
  localContactsBox.deleteAll(del);
  var data = {'add': add, 'del' : del};
  String dataJson = jsonEncode(data);

  return dataJson;
}


Future<void> sync(Box localContactsBox, String customerHash) async {
  String body = await getBoxDelta(localContactsBox);
  print(body);

  final response = await http
      .post(Uri.parse('http://10.0.2.2:8080/syncservice'), // TODO: correct link
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'customerHash': customerHash,
    },
    body: body,
  );
  print('responsecode-> ${response.statusCode}');
  if (response.statusCode == 200) {
    print('response->${response.body}');
    syncBox(localContactsBox, jsonDecode(response.body)) ;
  }
  else {
    throw Exception('Failed to get response');
  }
}

void syncBox(Box localContactsBox,dynamic response){
  for (String key in response['tap']){
    print('tap->$key');
    LocalContact contact = localContactsBox.get(key);
    contact.isRegistered = true;
    contact.action = '';
    localContactsBox.put(key, contact);
  }
  for (String key in response['notTap']){
    print('notTap->$key');
    LocalContact contact = localContactsBox.get(key);
    contact.isRegistered = false;
    contact.action = '';
    localContactsBox.put(key, contact);
  }
}

