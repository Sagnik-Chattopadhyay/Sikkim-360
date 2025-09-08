
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  Manuscripts extends StatelessWidget{
  const Manuscripts ({super.key});

  @override

  Widget build(BuildContext context)
  {
    return  Scaffold(
      appBar: AppBar(
          title: Text( 'Manuscripts')
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Back to homescreen')),
      ),
    );
  }
}