abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> userData;

  UserLoaded(this.userData);

  String get userName {
    return userData['name'] ?? 
           userData['username'] ?? 
           userData['displayName'] ?? 
           'User';
  }

  String? get profileImage => userData['profileImage'];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}