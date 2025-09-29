

import 'package:ofair/domain/model/user_model.dart';

abstract class UsersRepository {
     Future<List<UserModel>> getUsers();
}