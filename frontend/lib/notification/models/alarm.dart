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

  void connectAndListenTwo(int user, String id, String event){
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit(event, {
        "userId": 2,
        "postId": 1
      });
    });

    socket.on(event, (data) => streamSocket.addResponse(data));
    socket.onDisconnect((_) => print('disconnect'));
  }
}

