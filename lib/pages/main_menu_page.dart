import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/pages/create_room_page.dart';
import 'package:multiplayer_tick_tac_toe/pages/join_room_page.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:multiplayer_tick_tac_toe/responsive/responsive.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_button.dart';
import 'package:multiplayer_tick_tac_toe/widgets/ping_indicator.dart';

import '../utils/utils.dart';

class MainMenuPage extends StatefulWidget {
  static String routeName = '/main-menu-page';

  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final Socketservice _socketservice = Socketservice();
  StreamSubscription? _uriLinkStreamSubscription;
  Timer? _pingTimer;

  void pushToCreateRoomPage(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomPage.routeName);
  }

  void pushToJoinRoomPage(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomPage.routeName);
  }

  @override
  void initState() {
    super.initState();
    initUriHandler(context);
    _uriLinkStreamSubscription = setUriLinkStream(context);
    _socketservice
        .setContextForOnConnect(context); //setter for  context in internal
    _socketservice.connectionStatusListener(context);
    _pingTimer = startPingTimer(context);
    _socketservice.pongListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _pingTimer?.cancel();
    _uriLinkStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
            child: SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const PingIndicator(),
            ],
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.sizeOf(context).width / 10),
                        child: const Text(
                          'Multiplayer\nTic Tac\nToe',
                          style: TextStyle(
                              fontSize: 50,
                              shadows: [Shadow(color: Colors.blue,blurRadius: 40,offset: Offset.zero)]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CustomButton(
                          onTap: () => pushToCreateRoomPage(context),
                          text: 'Create Room',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            onTap: () => pushToJoinRoomPage(context),
                            text: 'Join Room'),
                      ],
                    ),
                  )
                ]),
          ),
        ],
      ),
    )));
  }
}
