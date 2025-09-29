abstract class RegisterEvent {

}






class RegisterUserEvent extends RegisterEvent {
  
  final String email;
  final String password;
  
  RegisterUserEvent({required this.email, required this.password});

  

}


