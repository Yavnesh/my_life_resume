import 'package:flutter/material.dart';
import 'package:my_life_resume/homeScreen.dart';
import '../splashScreen.dart';
import 'auth_service.dart';
import 'user_modal.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService=Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_,AsyncSnapshot<User?>snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          final User?user=snapshot.data;
          return user==null ? SplashScreen() : HomeScreen();
        }else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}


