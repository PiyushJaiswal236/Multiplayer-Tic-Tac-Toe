import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:multiplayer_tick_tac_toe/pages/game_page.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/game_service.dart';
import 'package:multiplayer_tick_tac_toe/resources/socket_client.dart';
import 'package:multiplayer_tick_tac_toe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Socketservice {
  static late Socket _socketclient;

  //Getter
  Socket get socketClient => _socketclient;

  //Setter
  void setContextForOnConnect(BuildContext value) {
    _socketclient = SocketClient.instance(value).socket!;
  }

  //EMITS

  void ping(int startTime) {
    _socketclient.emit("pinggg", {'startTime': startTime});
  }

  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketclient.emit("createRoom", {
        "nickname": nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketclient.emit("joinRoom", {
        "nickname": nickname,
        "roomId": roomId,
      });
    }
  }

  void onGridTap(int index, String roomId, List<String> displayElement) {
    if (displayElement[index] == "") {
      _socketclient.emit("gridTap", {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void requestReplay(BuildContext context, String roomId) {
    _socketclient.emit("requestReplay", {'roomId': roomId});
  }

  ///////LISTENER
  void connectionStatusListener(BuildContext context) {
    _socketclient.on('connect', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateConnectionStatus(true);
    });
    _socketclient.on('disconnect', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateConnectionStatus(false);
    });
    _socketclient.on("connect_error", (error) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateConnectionStatus(false);
      showSnackBar(context, "Connection Error");
    });
    _socketclient.on('error', (error) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateConnectionStatus(false);
      showSnackBar(context, "Client Error");
      if (kDebugMode) {
        log(
          error,
          name: "Socket Client Error",
        );
      }
    });
  }

  void roomCreatedListener(BuildContext context) {
    _socketclient.on("roomCreated", (room) {
      if (kDebugMode) {
        print("************");
        print(room);
        print("***********");
      }
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GamePage.routeName);
    });
  }

  void roomJoinedListener(BuildContext context) {
    _socketclient.on("roomJoined", (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GamePage.routeName);
    });
  }

  void updatePlayersListener(BuildContext context) {
    _socketclient.on("updatePlayers", (players) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer1(players[0]);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatePlayer2(players[1]);
    });
  }

  void roomUpdatedListener(BuildContext context) {
    try {
      _socketclient.on("roomUpdated", (room) {
        Provider.of<RoomDataProvider>(context, listen: false)
            .updateRoomData(room);
        print('************');
        print(room);
      });
    } catch (e) {
      print(e);
    }
  }

  void errorOccuredListener(BuildContext context) {
    _socketclient.on("errorOccured", (data) {
      showSnackBar(context, data);
    });
  }

  void tapAckListener(BuildContext context) {
    _socketclient.on('tapAck', (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      roomDataProvider.updateDisplayElement(data['index'], data['choice']);
      roomDataProvider.updateRoomData(data['room']);
    });
  }

  void matchConcludedListener(BuildContext context) {
    _socketclient.on("matchConluded", (data) {
      print(data);
      if (data['winnerDeclared']) {
        log("Someone Won !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        log("And he is ${data['winner']}");
        showGameDialogue(context, "${data['winner']['nickname']} Won");
      } else {
        log("OHHH NO !! it's a Draw !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        showGameDialogue(context, "It's a Draw");
      }
    });
  }

  void replayRequestedListener(BuildContext context) {
    _socketclient.on("replayRequested", (data) {
      Navigator.pop(context);
      showGameDialogue(context, data['nickname'] + " Wants A Rematch ԅ(¯﹃¯ԅ)");
    });
  }

  void gameRestartListener(BuildContext context) {
    _socketclient.on("gameRestart", (data) {
      print("___________________________________________________Game Restarted");
      print(data);

        restartBoard(context);

        restartMatch(context,data);
        Navigator.pop(context);

    });
  }

  void pongListener(BuildContext context) {
    _socketclient.on("pong", (startTime) {
      int endTime = DateTime.now().millisecondsSinceEpoch;
      final latency = endTime - startTime;
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateLatency(latency as int);
    });
  }

  void disconnect() {
    _socketclient.dispose();
  }
}
