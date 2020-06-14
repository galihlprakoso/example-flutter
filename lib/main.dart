import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/blocs/blocs.dart';
import 'package:flutter_firebase_login/repositories/repositories.dart';
import 'package:flutter_firebase_login/blocs/app_bloc_delegate.dart';
import 'package:flutter_firebase_login/screens/splash_screen/splash_screen.dart';
import 'package:flutter_firebase_login/screens/home_screen/home_screen.dart';
import 'package:flutter_firebase_login/screens/login_screen/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = AppBlocDelegate();
  final UserRepository userRepository = new UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
    : assert(userRepository != null),
    _userRepository = userRepository,
    super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is AuthenticationInitial) {
            return SplashScreen();
          }
          if(state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository);
          }
          if(state is AuthenticationSuccess) {
            return HomeScreen(name: state.displayName);
          }
          return Container();
        }
      )
    );
  }
}