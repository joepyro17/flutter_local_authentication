import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_authentication/screens/screens.dart';
import 'package:local_authentication/config/constant.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  AnimationController controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Check Device Supported and store in _supportState
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    controller.addListener(() {
      setState(() {

      });
    });

  }

  // Check whether there is local authentication available on this device or not
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e){
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  // Get available Biometrics
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print (e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    print(authenticated);

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');

    print(_authorized);
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -200.0,
            left: -150.0,
            child: Container(
              height: 400.0 * controller.value,
              width: 400.0 * controller.value,
              child: Image(image: AssetImage(kLoginImage1)),
            ),
          ),
          Positioned(
            top: 50.0,
            right: 50.0,
            child: Container(
              height: 50.0 * controller.value,
              width: 50.0 * controller.value,
              child: Image(image: AssetImage(kLoginImage2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 155.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Login Screen',
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 350.0,
                width: 350.0,
                child: Image(image: AssetImage(kLoginAvatar)),
              ),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: -70.0,
            child: Container(
              height: 200.0 * controller.value,
              width: 200.0 * controller.value,
              child: Image(image: AssetImage(kLoginImage2)),
            ),
          ),
          Positioned(
            bottom: -50.0,
            left: -70.0,
            child: Container(
              height: 200.0 * controller.value,
              width: 200.0 * controller.value,
              child: Image(image: AssetImage(kLoginImage2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 280.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Biometric Authentication',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 200.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 250.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Authenticate',
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      Icon(Icons.fingerprint),
                    ],
                  ),
                  onPressed: () {
                    print('on pressed');
                    _authenticate().then((value){
                      if(_authorized == 'Authorized') {
                        Navigator.pushNamed(context, DetailScreen.routeName);
                      } else {
                        print('Not authorized');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Authorization Failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
