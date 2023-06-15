import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class BroadcastScreen extends StatefulWidget {
  static const routeName = '/broadcast';

  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;

  @override
  void initState() {
    _initEngine();
    super.initState();
  }

  void _initEngine() async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      const RtcEngineContext(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
