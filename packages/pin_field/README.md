# pin_field

Pin Field for mobile sms code input.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pin_field/pin_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _pin = '';

  void _onPinValueChanged(String value) {
    setState(() {
      _pin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'the pin you entered:',
            ),
            Text(
              '$_pin',
              style: Theme.of(context).textTheme.display1,
            ),
            PinField(
              // padding
              padding: EdgeInsets.all(16.0),
              // how many pieces of your pin
              length: 6,
              // space between pins
              gap: 6.0,
              // hanlder for value changed
              onChanged: _onPinValueChanged,
              // handler for value submitted
              onSubmitted: _onPinValueChanged,
              // keyboard type
              keyboardType: TextInputType.numberWithOptions(signed: true),
              // input formatters
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ]
            )
          ],
        ),
      ),
    );
  }
}

```