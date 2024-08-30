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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomButton(
        onTap: () => pushToCreateRoomPage(context),
        text: 'Create Room',
      ),
      const SizedBox(
        height: 20,
      ),
      CustomButton(onTap: () => pushToJoinRoomPage(context), text: 'Join Room'),
      const PingIndicator()
    ])));
  }
}