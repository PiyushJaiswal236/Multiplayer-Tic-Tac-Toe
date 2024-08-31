
import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/pages/create_room_page.dart';
import 'package:multiplayer_tick_tac_toe/pages/game_page.dart';
import 'package:multiplayer_tick_tac_toe/pages/join_room_page.dart';
import 'package:multiplayer_tick_tac_toe/pages/main_menu_page.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return RoomDataProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgColor),
        home: const MainMenuPage(),
        routes: {
          MainMenuPage.routeName: (context) => const MainMenuPage(),
          CreateRoomPage.routeName: (context) => const CreateRoomPage(),
          JoinRoomPage.routeName: (context) => const JoinRoomPage(),
          GamePage.routeName: (context) => const GamePage(),
        },
        initialRoute: MainMenuPage.routeName,
      ),
    );
  }
}
