import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 1)
class LocalContact{

  @HiveField(0)
  String? name;

  @HiveField(1)
  String photoUri;

  @HiveField(2)
  String customerHash;

  @HiveField(3)
  String? mobile;

  @HiveField(4)
  String vpa;

  @HiveField(5)
  String upiNumber8;

  @HiveField(6)
  String upiNumber9;

  @HiveField(7)
  String upiNumber;

  @HiveField(8)
  bool isBlocked;

  @HiveField(9)
  bool isRegistered;

  @HiveField(10)
  bool isSynced;

  @HiveField(11)
  String action;

  LocalContact(
    {required this.name,
      required this.photoUri,
      required this.customerHash,
      required this.mobile,
      required this.vpa,
      required this.upiNumber8,
      required this.upiNumber9,
      required this.upiNumber,
      required this.isBlocked,
      required this.isRegistered,
      required this.isSynced,
      required this.action,}
    );

}