import 'dart:async';
import 'package:flutter/material.dart';

class CallLog {
  final String id;
  final String name;
  final String avatarUrl;
  final String time;
  final bool isMissed;
  final bool isIncoming;
  final bool isVideo;

  CallLog({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.time,
    required this.isMissed,
    required this.isIncoming,
    this.isVideo = false,
  });
}

class CallProvider extends ChangeNotifier {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = true;
  bool _isCallConnected = false;
  int _durationSeconds = 0;
  Timer? _callTimer;

  String _callerName = 'Liam Carter';
  String _callerAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80';
  bool _isIncoming = false;

  // Mock Call Logs Database
  final List<CallLog> _callLogs = [
    CallLog(
      id: '1',
      name: 'Liam Carter',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      time: 'Today, 10:15 AM',
      isMissed: false,
      isIncoming: true,
      isVideo: false,
    ),
    CallLog(
      id: '2',
      name: 'Sophia Rose',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
      time: 'Yesterday, 3:40 PM',
      isMissed: true,
      isIncoming: true,
      isVideo: true,
    ),
    CallLog(
      id: '3',
      name: 'James Anderson',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
      time: 'August 19, 11:20 AM',
      isMissed: false,
      isIncoming: false,
      isVideo: false,
    ),
    CallLog(
      id: '4',
      name: 'Sophia Rose',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
      time: 'August 18, 5:10 PM',
      isMissed: false,
      isIncoming: false,
      isVideo: true,
    ),
    CallLog(
      id: '5',
      name: 'Mason Mount',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
      time: 'August 16, 9:05 AM',
      isMissed: true,
      isIncoming: true,
      isVideo: false,
    ),
  ];

  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isVideoOn => _isVideoOn;
  bool get isCallConnected => _isCallConnected;
  int get durationSeconds => _durationSeconds;
  String get callerName => _callerName;
  String get callerAvatar => _callerAvatar;
  bool get isIncoming => _isIncoming;
  List<CallLog> get callLogs => _callLogs;

  String get formattedDuration {
    final minutes = (_durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void startCall(String name, String avatarUrl, {required bool isIncoming, bool isVideo = false}) {
    _callerName = name;
    _callerAvatar = avatarUrl;
    _isIncoming = isIncoming;
    _isMuted = false;
    _isSpeakerOn = false;
    _isVideoOn = isVideo;
    _durationSeconds = 0;

    if (isIncoming) {
      _isCallConnected = false;
    } else {
      // Connect outgoing call after 2 seconds ringing simulator
      _isCallConnected = false;
      Timer(const Duration(seconds: 2), () {
        _isCallConnected = true;
        _startTimer();
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void acceptCall() {
    _isCallConnected = true;
    _isIncoming = false;
    _startTimer();
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void toggleVideo() {
    _isVideoOn = !_isVideoOn;
    notifyListeners();
  }

  void _startTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durationSeconds++;
      notifyListeners();
    });
  }

  void endCall() {
    _callTimer?.cancel();
    _callTimer = null;
    _isCallConnected = false;
    _durationSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }
}
