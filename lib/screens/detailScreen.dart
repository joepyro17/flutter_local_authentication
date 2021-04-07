import 'package:flutter/material.dart';
import 'package:local_authentication/screens/screens.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = 'detail';

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
        backgroundColor: Colors.purple,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Authenticate Successfully',
                style: TextStyle(color: Colors.purple, fontSize: 20.0),
              ),
              SizedBox(
                height: 200.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Return to Login Screen',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    Icon(Icons.arrow_back),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },

              )
            ],
          )
        ],
      ),
    );
  }
}
