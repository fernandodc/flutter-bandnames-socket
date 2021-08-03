import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  late IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.Connecting;

  SocketService() {
    print("Se inicio la instancia");
    this._initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void _initConfig() {
    //IO.Socket socket;
    this._socket = IO.io(
        'http://192.168.1.10:3000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    this._socket.connect();
    this._socket.emit('mensaje', 'saludando desde flutter');
    //socket.on('connect', (data) => print('conectado desde flutter'));
    this._socket.onConnect((data) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (data) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
