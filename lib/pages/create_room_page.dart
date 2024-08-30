import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:multiplayer_tick_tac_toe/responsive/responsive.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_button.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_text.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_textfield.dart';

class CreateRoomPage extends StatefulWidget {
  static String routeName = '/create-room-page';

  const CreateRoomPage({super.key});

  @override
  State<StatefulWidget> createState() => _createRoomState();
}

class _createRoomState extends State<CreateRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final Socketservice _socketService = Socketservice();


  @override
  void initState() {
    super.initState();
    _socketService.roomCreatedListener(context);
    _socketService.roomUpdatedListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
                  shadows: const [Shadow(color: Colors.blue,blurRadius: 10)],
                  text: 'Create Room',
                  fontSize: 70),
              SizedBox(
                height: size.height * 0.08,
              ),
              CustomTextfield(controller: _nameController, hintText: "Your NickName"),
              SizedBox(height: size.height*0.02,),
              CustomButton(onTap: ()=>_socketService.createRoom(_nameController.text), text: "Create")
            ],
          ),
        ),
      ),
    );
  }
}
