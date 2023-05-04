import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'contact_model.dart';
import 'package:hive/hive.dart';

class ContactFetch{
  String numberCheck(String? number){
    if (number==null){
      return '';
    }
    number = number.replaceAll(RegExp(r'[^0-9]'),'');
    if (number.length==12 && RegExp(r'91').matchAsPrefix(number)!=null){
      return number;
    }
    return '';
  }


  Future<PermissionStatus> _getContactPermissions() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    }
    return permission;
  }

  Future<Box> openBox() async {
    Box box;
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('localContactBox');
    print('Box opened');
    return box;
  }

  Future<List<LocalContact>> getContactsList() async {
    List<LocalContact> contacts = [];
    String? number;

    final PermissionStatus permissionStatus = await _getContactPermissions();
    if (permissionStatus == PermissionStatus.granted){
      List<Contact> contactList = await ContactsService.getContacts();
      //print('contacts length-> ${contactList.length}');
      var cnt = 0;
      for (Contact contact in contactList){
        // string manipulation for mobile(indian number, mobile number, remove +91)
        number = numberCheck(contact.phones?.first.value);
        if (number==''){
          continue;
        }
        contacts.add(
            LocalContact(
                name: contact.displayName,
                photoUri: '',
                customerHash: '',
                mobile: number,
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
}