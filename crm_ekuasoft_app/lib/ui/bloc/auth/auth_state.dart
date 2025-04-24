part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  
  final storage = const FlutterSecureStorage();

  @override
  List<Object> get props => [];
  
  Future<String> readToken() async {
    try {
      String rspFinal = 'home';

      var rspReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var rspLog = await storage.read(key: 'RespuestaLogin') ?? '';
                
      var termCond = await storage.read(key: 'AceptaTermCond');

      await storage.write(key: 'fecMem', value: '');
      await storage.write(key: 'idMem', value: '');

      if(rspReg.isEmpty && rspLog.isEmpty){
        rspFinal = '';
      }
      else {
        if(termCond == null || termCond == 'false'){
          rspFinal = 'termCond';
        }
        if(rspLog.isEmpty && rspFinal == 'home'){
          rspFinal = 'log';
        }        
      }
      
      return rspFinal; 
    }
    catch(ex) {
      return '';
    }
    
  }

}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthNoInternet extends AuthState {}

class AuthGpsFake extends AuthState {}

class ValidLicenseKey extends AuthState {}

class InvalidLicenseKey extends AuthState {}

class PinCompleted extends AuthState {}

class PinSubmitted extends AuthState {}

class InvalidPin extends AuthState {}

class ValidPin extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}


