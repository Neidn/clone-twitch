import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '/config.dart';

import '/models/user.dart';

import '/providers/user_provider.dart';

class BroadcastScreen extends StatefulWidget {
  static const routeName = '/broadcast';

  final bool isBroadcaster;
  final String channelId;

  const BroadcastScreen({
    super.key,
    required this.isBroadcaster,
    required this.channelId,
  });

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;

  final List<int> _remoteUid = [];

  @override
  void initState() {
    _initEngine();
    super.initState();
  }

  void _initEngine() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();

    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _addListeners();

    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }
    await _engine.enableAudio();
    await _engine.startPreview();

    _joinChannel();
  }

  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('onJoinChannelSuccess $connection $elapsed');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint('onUserJoined $connection $remoteUid $elapsed');
          setState(() {
            _remoteUid.add(remoteUid);
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint('onUserOffline $connection $remoteUid $reason');
          setState(() {
            _remoteUid.removeWhere((element) => element == remoteUid);
          });
        },
        onLeaveChannel: (connection, stats) {
          debugPrint('onLeaveChannel $connection $stats');
          setState(() {
            _remoteUid.clear();
          });
        },
      ),
    );
  }

  void _joinChannel() async {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _engine.joinChannelWithUserAccount(
      token: appToken,
      channelId: widget.channelId,
      userAccount: user.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo(User user) {
    if (_remoteUid.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid[0]),
          connection: const RtcConnection(channelId: 'channelId'),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
