import 'dart:async';

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

  void connectAndListenOne(String name, String content, String event){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit(name, content);
    });

    socket.on(event, (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }

  // Subscribe
  void subscribeAlarm(int user){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('user connect');
      socket.emit("subscribe", {
        "userId": user,
      });
    });

    socket.on("subscribe", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
  }

  // Last
  void lastAlarm(int user){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('alarm connect');
      socket.emit("last", {
        "userId": user,
      });
    });

    socket.on("last", (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
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

