import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _eventCollection = _firestore.collection('events');
final CollectionReference _userCollection = _firestore.collection('users');

class EventDatabase {
  static Future<void> addEvent({
    String? userId,
    String? name,
    String? description,
    String? location,
    String? category,
    String? event_image,
    String? doe,
    String? email,
  }) async {
    DocumentReference documentReference =
    _eventCollection.doc(DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "title": name,
      "description": description,
      "postImage": event_image,
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "location": location,
      "category": category,
      "doe": doe,
      "email": email,
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("Event added to database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readAllEvents(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('events').where('userId', isEqualTo: userId).snapshots();
  }

}

class UserDatabase {
  static Future<void> addUser({
    String? userId,
    String? name,
    String? phone,
    String? user_image,
    String? address,
    String? dob,
    String? email,
  }) async {
    DocumentReference documentReference =
    _userCollection.doc(DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "name": name,
      "phone": phone,
      "user_image": user_image,
      "address": address,
      "dob": dob,
      "email": email,
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString()
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("User added to database"))
        .catchError((e) => print(e));
  }

  static readUser(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('users').where('userId', isEqualTo: userId).snapshots();
  }
}
