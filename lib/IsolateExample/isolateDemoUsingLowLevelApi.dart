import 'dart:isolate';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
class UsingHighLevel extends StatefulWidget {
  @override
  _UsingHighLevelState createState() => _UsingHighLevelState();
}

class _UsingHighLevelState extends State<UsingHighLevel> {
  Isolate _isolate;
  bool _running = false; // indicate that isolate running or not
  bool _paused = false; // indicate that isolate paused or not
  String _message = ''; //this going to hold message from isolate
  String _threadStatus = ''; //this going to indicate status of isolate
  ReceivePort _receivePort; //this is a port main isolate will listening
  Capability _capability;  // Todo //

  void start() async{
    if(_running){
      return;// start the isolate
    }

    setState(() {
      _running = true;
      print(_running);
      _message = 'Starting..';
      print(_message);

      _threadStatus = 'Running..';
      print(_threadStatus);
    });
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateHandler, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: (){
      print("Done");
      setState(() {
        _threadStatus = 'Stoped';
      });
    });
  }

  void _pause() { // pause or receive the isolate

    if(null!= _isolate){
      _paused ? _isolate.resume(_capability):_capability = _isolate.pause();
    setState(() {
      _paused = !_paused;
      _threadStatus = _paused ? 'Paused' : 'Resumed';
    });
    }

  }
  void stop(){ // stop the isolate and kill it
    if(null!=_isolate){
      setState(() {
        _running = false;
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }

  }

  static void _isolateHandler(SendPort sendPort){ // this is a entrypoint function
    heavyOperation(sendPort);
  }

  void _handleMessage(dynamic data){
    setState(() {
      _message = data;
    });
  }
  static void heavyOperation(SendPort sendPort) async{
    int count = 100;
    while(true){
      int sum=0;
      for(int i=0;i< count;i++){
        sum += await computeSum(100);
      }
      count +=10;
      sendPort.send(sum.toString());

    }



  }

  static Future<int> computeSum(int num){
    Random random = Random();
    return Future((){
      int sum=0;
      for(int i=0;i<num;i++){
        sum +=random.nextInt(100);
      }
      return sum;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isolate_HightLevelApi')
      ),

      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            !_running?
            OutlineButton(
              child: Text('Start isolate'),
              onPressed: (){
                start();
                print("click");
              },
            ): SizedBox(),
            _running? OutlineButton(
              child: Text(_paused? 'Resume isolate' : 'pause isolate'),
              onPressed: (){
                _pause();
              },
            ): SizedBox(),
            _running?OutlineButton(
              child: Text("Stop Isolate"),
              onPressed: (){
                stop();
              },
            ):SizedBox(),
            SizedBox(
              height: 20.0,
            ),
            Text(
              _threadStatus,
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              _message,
              style: TextStyle(
                  fontSize: 20.0,
                color: Colors.green
              ),
            )

          ],
        ),
      ),
    );
  }
}
