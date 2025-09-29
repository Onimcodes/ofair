class RegisterResponseModel {
  final String userId;
  final String token;
  final String profilePic;
  final List<String> errors;
  final bool result;


  RegisterResponseModel({ required this.userId, required this.token,  required this.profilePic, required this.errors , required this.result});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(userId:json['userId'] , token:json ['token'], result: json['result'], profilePic: json['profilePic'], errors: json['errors'], );
  }
}


class LoginResponseModel {
     final String userId;
  final String token;
  final String profilePic;
  final List<String> errors;
  final bool result;


  LoginResponseModel({ required this.userId, required this.token,  required this.profilePic, required this.errors , required this.result});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(userId:json['userId'] , token:json ['token'], result: json['result'], profilePic: json['profilePic'], errors: json['errors'], );
  }
}


class RegisterRequestModel {
  final String email;
  final String password;

  final String? userRole;


  RegisterRequestModel({required this.email, required this.password, this.userRole});


Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'password' : password,
      'userRole' : 'User'
    };
  }


}

class LoginRequestModel {
  final String email;
  final String password;
  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson(){
    return {
      'email' : email,
      'password' : password
    };
  }
  
}