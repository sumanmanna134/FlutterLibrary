import 'dart:async';

import 'package:flutteradvanced/Bloc_withApi/Models/NewsApiModel.dart';
import 'package:flutteradvanced/Bloc_withApi/Services/ApiManager.dart';

enum NewsAction {Fetch, Delete}

class ApiBloc{

  final _api_manager = API_Manager();
  final _stateStreamController = StreamController<List<Article>>();

  //input Property
  StreamSink<List<Article>> get _newsSink => _stateStreamController.sink;
  //output Property
  Stream<List<Article>> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;


  ApiBloc(){
    _eventStream.listen((event)async {
      if(event == NewsAction.Fetch)
      {
        try {
          var news = await _api_manager.getNews();
          _newsSink.add(news.articles);
        } on Exception catch (e) {
          _newsSink.addError('Something Went wrong');
        }

      }
    });
  }


  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

