import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiky/core/models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser(String uid);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  UserRemoteDatasourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const _collection = 'users';

  @override
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection(_collection).doc(user.uid).set(user.toJson());
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection(_collection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }
}