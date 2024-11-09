import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links2/uni_links.dart';

Socketservice _socketservice = Socketservice();

void showSnackBar(BuildContext context, String data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(data),
  ));
}

void showGameDialogue(BuildContext context, String text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          content: const SizedBox(
            height: 1,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _socketservice.requestReplay(
                      context,
                      Provider.of<RoomDataProvider>(context, listen: false)
                          .roomData['_id']);
                },
                child: const Text('Play Again')),
          ],
        );
      });
}

Timer? startPingTimer(BuildContext context) {
  Timer? pingTimer;
  pingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    _socketservice.ping(startTime);
  });

  return pingTimer;
}

void shareInviteLink(String roomId) {
  Share.share(
      'Join my game room: https://multiplayer-tic-tac-toe-78eh.onrender.com/room?id=$roomId');
}

StreamSubscription? setUriLinkStream(BuildContext context) {
  Socketservice socketservice = Socketservice();

  return uriLinkStream.listen((Uri? uri) {
    if (kDebugMode) {
      print("Opening link via app");
    }

    if (uri != null) {
      final String? roomId = uri.queryParameters['id'];
      if (kDebugMode) {
        print('Received deep link: ${uri.toString()}');
        print('Room ID: $roomId');
      }

      socketservice.roomJoinedListener(context);
      socketservice.joinRoom("GuestInvitee", roomId!);
    }
  }, onError: (err) {
    if (kDebugMode) {
      print('Failed to receive deep link: $err');
    }
  });
}

void initUriHandler(BuildContext context) async {
  try {
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      Socketservice socketservice = Socketservice();
      final String? roomId = initialUri.queryParameters['id'];
      if (kDebugMode) {
        print('Initial deep link: ${initialUri.toString()}');
        print('Room ID: $roomId');
      }
      // Handle the initial deep link here
      socketservice.roomJoinedListener(context);
      socketservice.joinRoom("GuestInvitee", roomId!);
    }
  } on PlatformException {
    if (kDebugMode) {
      print('Failed to receive initial link');
    }
  }
}

void copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  showSnackBar(context, "Room Id Copied");
}
