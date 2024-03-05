import 'package:biometrics_authentication/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum SupportState{
  unknown,
  supported,
  unsupported,
}

class _AuthScreenState extends State<AuthScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void initState() {
    auth.isDeviceSupported().then((bool isSupported) => setState(()=>supportState =isSupported ? SupportState.supported : SupportState.unsupported ));
    super.initState();
    checkBiometric();
    getAvailableBiometrics();

  }

  Future<void>checkBiometric () async{
    late bool canCheckBiometric;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
      print("Biometric supported: $canCheckBiometric");
    }on PlatformException catch (e) {
      print(e);
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async{
    late List<BiometricType> biometricTypes;
    try{
      biometricTypes= await auth.getAvailableBiometrics();
      print("supported biometrics $biometricTypes");
      
    }on PlatformException catch (e) {
      print(e);
    }

    if(!mounted){
      return;
    }
    setState(() {
      availableBiometrics= biometricTypes;
    });

  }


  Future<void> authenticateWithBiometrics() async{
    try{
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerprint or face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        )
        );
        if(!mounted){
          return;
        }
        if(authenticated){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
        }

    }on PlatformException catch(e){
      print(e);
      return;

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              supportState == SupportState.supported
              ? "Biometric is supported on this device"
              :supportState == SupportState.unsupported
              ?"Biometric is not supported on this device"
              :'Checking for biometric support...',

              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: supportState == SupportState.supported
                ? Colors.green
                :supportState == SupportState.unsupported
                ?Colors.red
                :Colors.grey
              ),
            ),
            const SizedBox(height: 20,),

            Text('Supported biometrics: $availableBiometrics'),
            const SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  width: 200,
                  height: 200,
                  image: AssetImage('assets/f.gif')),

                  ElevatedButton(onPressed: authenticateWithBiometrics, child: const Text('authenticate with Face Id'))
              ],)

          ],
        ),
      ),
    );
  }
}