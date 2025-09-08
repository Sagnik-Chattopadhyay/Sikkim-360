
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class event extends StatelessWidget{
  const event({super.key});

  @override

  Widget build(BuildContext context)
  {
    return  Scaffold(
      appBar: AppBar(
          title: Text( 'Event planner')
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Back to homescreen')),
      ),
    );
  }
}