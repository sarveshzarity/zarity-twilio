import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zarity_twilio/conference/conference_cubit.dart';

import 'package:zarity_twilio/room/join_room_cubit.dart';
import 'package:zarity_twilio/shared/twilio_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../conference/conference_page.dart';

class JoinRoomPage extends StatefulWidget {
  JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  @override
  void didChangeDependencies() {
    //checkPermission();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) =>
                RoomCubit(backendService: TwilioFunctionsService.instance),
            child: BlocConsumer<RoomCubit, RoomState>(
                listener: (context, state) async {
              if (state is RoomLoaded) {
                await Navigator.of(context).push(
                  MaterialPageRoute<ConferencePage>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) =>
                          // ConferencePage(roomModel: bloc),
                          BlocProvider(
                            create: (BuildContext context) => ConferenceCubit(
                              identity: state.identity,
                              token: state.token,
                              name: state.name,
                            ),
                            child: const ConferencePage(),
                          )),
                );
              }
            }, builder: (context, state) {
              var isLoading = false;
              RoomCubit bloc = context.read<RoomCubit>();
              if (state is RoomLoading) {
                isLoading = true;
              }
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              key: const Key('enter-name'),
                              decoration: InputDecoration(
                                labelText: 'Enter your name',
                                enabled: !isLoading,
                              ),
                              controller: _nameController,
                              onChanged: (newValue) =>
                                  context.read<RoomCubit>().name = newValue,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            (isLoading == true)
                                ? const LinearProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      await bloc.submit();
                                    },
                                    child: const Text('Enter the room')),
                            (state is RoomError)
                                ? Text(
                                    state.error,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            }),
          ),
        ),
      ),
    );
  }

  void checkPermission() async {
    var status = await Permission.bluetooth.status;
    if (status.isDenied) {
      Permission.bluetooth.request();
    }

// // You can can also directly ask the permission about its status.
//     if (await Permission.location.isRestricted) {
//       // The OS restricts access, for example because of parental controls.
//     }
  }
}
