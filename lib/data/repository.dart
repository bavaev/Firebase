import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase/business/models/item.dart';

abstract class ItemRepository {
  Stream<List<Item>> purchases();

  void dispose();
  void data(bool sort);
  void registration(String email, String password);
  void auth(bool login, String email, String password);
  void googleAuth(bool login);
  void add(String value);
  void update(String id, bool value);
}

class ItemRepositoryFirestore extends ItemRepository {
  final _loadedData = StreamController<List<Item>>();
  final _cache = <Item>[];

  @override
  void dispose() {
    _loadedData.close();
  }

  @override
  void registration(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<UserCredential?> auth(bool login, String email, String password) async {
    if (login) {
      await FirebaseAuth.instance.signOut();
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
    return null;
  }

  @override
  Future<UserCredential?> googleAuth(bool login) async {
    if (login) {
      await FirebaseAuth.instance.signOut();
    } else {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          return await FirebaseAuth.instance.signInWithCredential(credential);
        }
      }
    }
    return null;
  }

  @override
  void data(bool sort) {
    FirebaseFirestore.instance.collection('purchases').orderBy('name', descending: sort).snapshots().listen((techniques) {
      _cache.clear();
      techniques.docs.forEach((item) {
        _cache.add(Item(id: item.id, name: item['name'], purchased: item['purchased']));
      });
      _loadedData.add(_cache);
    });
  }

  @override
  void add(String value) {
    FirebaseFirestore.instance.collection('purchases').add({
      'name': value,
      'purchased': false,
    });
  }

  @override
  void update(String id, bool value) {
    FirebaseFirestore.instance.collection('purchases').doc(id).update({
      'purchased': value,
    });
  }

  @override
  Stream<List<Item>> purchases() => _loadedData.stream;
}
