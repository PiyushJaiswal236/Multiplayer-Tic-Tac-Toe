import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/models/player.dart';

class RoomDataProvider extends ChangeNotifier{
  Map<String,dynamic> _roomData ={};

  List<String> _displayElement=['','', '','','','','','',''];

  bool _isConnected = false;
  int? _latency;


  int _filledBoxes=0;
  Player _player1 =  Player(nickname: "", socketId: '', points: 0.0, playerType: 'X');

  Player _player2 =  Player(nickname: "", socketId: '', points: 0.0, playerType: 'O');


  Map<String,dynamic> get roomData => _roomData;
  List<String> get displayElement=>_displayElement;
  Player get player1 => _player1;
  Player  get player2=> _player2;
  int? get latency => _latency;
  bool get isConnected =>_isConnected;
  int get filledBoxes => _filledBoxes;

  void updateLatency(int latency){
    _latency=latency;
    notifyListeners();
  }

  void updateConnectionStatus(bool status){
    _isConnected = status;
    notifyListeners();
  }

  void updateRoomData( Map<String,dynamic> data){
    _roomData= data;
    notifyListeners();
  }
  void updatePlayer1( Map<String,dynamic> player1Data){
    _player1 = Player.fromMap(player1Data);
    notifyListeners();
  }
  void updatePlayer2( Map<String,dynamic> player2Data){
    _player2 = Player.fromMap(player2Data);
    notifyListeners();
  }
  void updateDisplayElement(int index,String choice){
    _displayElement[index]=choice;
    _filledBoxes++;
    notifyListeners();
  }
  void updateFilledBoxes(int value){
    _filledBoxes=value;
    notifyListeners();
  }
  void clearBoard(){
    _displayElement =['','', '','','','','','',''];
    notifyListeners();
  }
}