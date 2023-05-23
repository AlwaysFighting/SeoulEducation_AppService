import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket{

  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket =StreamSocket();

class ConnectSocket {

  // Subscribe
  Future<void> subscribeAlarm(int user) async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      socket.emit("subscribe", {
        "userId": user,
      });
    });

    socket.on("subscribe", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
  }

  // Last
  void lastAlarm() async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      print('alarm connect');
      socket.emit("last", {
        "userId": user,
      });
    });

    socket.on("last", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('last disconnect'));
  }

  // Comment
  void commentAlarm(int user, int post){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('comment connect');
      socket.emit("comment", {
        "userId": user,
        "postId": post
      });
    });

    socket.on("comment", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
  }

  // Reply
  void replyAlarm(int user, int comment){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('reply connect');
      socket.emit("reply", {
        "userId": user,
        "commentId": comment
      });
    });

    socket.on("reply", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
  }
}
