import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ConnectSocket {

  // Subscribe
  Future<void> subscribeAlarm(int user) async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      print('subscribe connect');
      socket.emitWithAck('subscribe', {
        "userId": user,
      }, ack: (data) {
        print('ack $data');
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    });
  }

  // Last
  Future<void> lastAlarm() async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      print('last connect');
      socket.emitWithAck('last', {
        "userId": user,
      }, ack: (data) {
        print('ack $data');
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    });
  }

  // Comment
  commentAlarm(int post) async {

    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt('userID') ?? 0;

    socket.onConnect((_) {
      print('comment connect');
      socket.emitWithAck('comment', {
        "userId": user,
        "postId": post,
      }, ack: (data) {
        print('ack $data');
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    });
  }

  // Reply
  Future<void> replyAlarm(int user, int comment) async {
    IO.Socket socket = IO.io('http://localhost:8080',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('reply connect');
      socket.emitWithAck('reply', {
        "userId": user,
        "commentId": comment
      }, ack: (data) {
        print('ack $data');
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    });
  }
}

