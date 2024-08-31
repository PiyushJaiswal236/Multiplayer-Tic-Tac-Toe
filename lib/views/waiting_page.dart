import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/responsive/responsive.dart';
import 'package:multiplayer_tick_tac_toe/utils/utils.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_button.dart';
import 'package:multiplayer_tick_tac_toe/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  late TextEditingController roomIdController;

  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(
        text: Provider.of<RoomDataProvider>(context, listen: false)
            .roomData['_id'],);
  }


  @override
  void dispose() {
    super.dispose();
    roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("waiting for player to join"),
          const SizedBox(height: 20,),
          CustomTextfield(controller: roomIdController, hintText: "",isReadOnly: true,),
          const SizedBox(height: 20,),
          CustomButton(onTap: (){}, text: 'Copy ID'),
          const SizedBox(height: 20,),
          CustomButton(onTap: (){shareInviteLink(roomIdController.text);}, text: "Share Link"),
      
        ],
      ),
    );
  }
}
