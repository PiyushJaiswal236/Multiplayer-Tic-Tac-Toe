import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_button.dart';

import '../responsive/responsive.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';

class JoinRoomPage extends StatefulWidget{
  static String routeName = '/join-room-page';

  const JoinRoomPage({super.key});

  @override
  State<StatefulWidget> createState() => _joinRoomState();

}

class _joinRoomState extends State<JoinRoomPage>{

  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _roomIdController= TextEditingController();
  final Socketservice _socketservice = Socketservice();


  @override
  void initState() {
    super.initState();
    _socketservice.roomJoinedListener(context);
    _socketservice.updatePlayersListener(context);
    _socketservice.errorOccuredListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  shadows: const [Shadow(color: Colors.blue,blurRadius: 40)],
                  text: 'Join Room',
                  fontSize: 70),
              SizedBox(
                height: size.height * 0.08,
              ),
              CustomTextfield(controller: _nameController, hintText: "Your NickName"),
              SizedBox(height: size.height*0.02,),
              CustomTextfield(controller: _roomIdController, hintText: "Room Id"),
              SizedBox(height: size.height*0.02,),
              CustomButton(onTap: ()=>_socketservice.joinRoom(_nameController.text,_roomIdController.text), text: "Join Room")
            ],
          ),
        ),
      ),
    );
  }


}