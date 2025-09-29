

import 'package:ofair/domain/logics/validators.dart';

mixin EmailPassValidators {
    String? validateEmail(String? email) {
        return Validator.validateEmail(email);
    }

    String? validatePassword(String? password){
        return Validator.validatePassword(password);
    }
}