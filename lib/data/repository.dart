import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase/business/models/item.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class ItemRepository {
  Stream<List<Item>> purchases();

  void dispose();
  void data(bool sort);
  void auth(bool login);
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
  Future<UserCredential?> auth(bool login) async {
    if (login) {
      await FirebaseAuth.instance.signOut();
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
