import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photomemo/model/photomemo.dart';

class FirebaseController {
  static Future signIn(String email, String password) async {
    UserCredential auth =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<List<PhotoMemo>> getPhotoMemos(String email) async {
    QuerySnapshot querySnapShot = await FirebaseFirestore.instance
        .collection(PhotoMemo.COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .get();

    var result = <PhotoMemo>[];
    if (querySnapShot != null && querySnapShot.docs.length != 0) {
      for (var doc in querySnapShot.docs) {
        result.add(PhotoMemo.deserialized(doc.data(), doc.id));
      }
    }

    return result;
  }
}
