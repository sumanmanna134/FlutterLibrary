import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  Future<void> computeFuture = Future.value();

  int number = 40;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Performance using Isolate"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimationWidget(),
              addButton(),
              addButton2(),
              RaisedButton(
                onPressed: (){},
              )
            ],

          ),
        ),
      ),
    );
  }

  addButton(){
    return FutureBuilder(
      future: computeFuture,
      builder: (context,snapshot){
        return OutlineButton(
          child: const Text('Main Isolate'),
          onPressed: createMainIsolateCallback(context,snapshot),
        );
      },
    );
  }
  addButton2(){
    return FutureBuilder(
      future: computeFuture,
      builder: (context,snapshot){
        return OutlineButton(
          child: const Text('Secondary Isolate'),
          onPressed: createSecondaryIsolateCallback(context,snapshot),
        );
      },
    );
  }

  VoidCallback createMainIsolateCallback(BuildContext context, AsyncSnapshot snapshot)
  {
    if(snapshot.connectionState == ConnectionState.done){
      return (){

        setState(() {
          computeFuture = computeOnMainIsolate().then((val){
              showSnackBar(context, 'main Isolate done ${val}');
              print('main Isolate done ${val}');
          });
        });

      };
    }else {
      return null;
    }
  }


  VoidCallback createSecondaryIsolateCallback(BuildContext context, AsyncSnapshot snapshot)
  {
    if(snapshot.connectionState == ConnectionState.done){
      return (){

        setState(() {

          computeFuture = computeOnSecondaryIsolate().then((val){

            showSnackBar(context, 'Secondary Isolate done ${val}');
            print('main Isolate done ${val}');

          });
        });



      };
    }else {
      return null;
    }
  }

  Future<int> computeOnMainIsolate() async {
    //doing in main thread
    
    return await Future.delayed(Duration(milliseconds: 100), () => fib(number));
  }

  Future<int> computeOnSecondaryIsolate() async {
    return await compute(fib,number);
  }



  showSnackBar(context, message){
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

int fib(int n){
  int number1 = n-1;
  int number2 = n-2;
  if(1==n){
    return 0;
  }else if (0==n){
    return 1;
  }else {
    return (fib(number1) + fib(number2));
  }
}

class AnimationWidget extends StatefulWidget {
  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<BorderRadius> _borderRadius;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this)
    ..addStatusListener((status) {  //listen to status
      //add a status listener
      if(status == AnimationStatus.completed){

        _animationController.reverse();
        

      }else if(status == AnimationStatus.dismissed){
        _animationController.forward();
      }
    });

    _borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(100),
      end: BorderRadius.circular(0.0),

    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear
    ));
    _animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderRadius,
      builder: (context, child){
        return Center(
          child: Container(
            child: FlutterLogo(
              size: 200,
            ),
            alignment: Alignment.bottomCenter,
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                colors: [Colors.black, Colors.black26],

              ),
                  borderRadius: _borderRadius.value,
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();

  }
}

