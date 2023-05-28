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

StreamSocket streamSocket = StreamSocket();

// 알림
class ConnectSocket {

  // Subscribe
  Future<void> subscribeAlarm(int user) async {
    print("subscribeAlarm 실행!");
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      print('subscribe connect');
      socket.emit('subscribe', {
        user,
      },);
    });
    socket.on('subscribe', (data) => streamSocket.addResponse);
  }

  // Last
  Future<void> lastAlarm() async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    ConnectSocket().subscribeAlarm(user);
    socket.onConnect((_) {
      print('last connect');
      socket.emit('last', {
        user,
      },);
    });
    socket.on('last', (data) => streamSocket.addResponse);
  }

  // Comment
  commentAlarm(int post) async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onDisconnect((_) => print('disconnect'));

    socket.onConnect((_) {
      print('comment connect');
      socket.emit('comment', {
        user,
        post,
      });
    });
    socket.on('comment', (data) => print(data));
  }

  // Reply
  Future<void> replyAlarm(int user, int comment) async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('reply connect');
      socket.emit('reply', {
        user,
        comment
      });
    });
    socket.on('reply', (data) => streamSocket.addResponse);
  }

}

