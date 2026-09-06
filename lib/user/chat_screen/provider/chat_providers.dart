// import 'dart:async';

// import 'package:chat_app/model/message_model.dart';
// import 'package:chat_app/services/chat_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatProvider extends ChangeNotifier {
//   final ChatServices _chatServices = ChatServices();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // =========================
//   // Controllers
//   // =========================

//   final TextEditingController messageController = TextEditingController();

//   final ScrollController scrollController = ScrollController();

//   // =========================
//   // Sending State
//   // =========================

//   bool _isSending = false;

//   String _errorMessage = '';

//   // =========================
//   // Selected Chat
//   // =========================

//   String? _selectedUserId;

//   // =========================
//   // Messages
//   // =========================

//   List<MessageModel> _activeMessages = [];

//   StreamSubscription<List<MessageModel>>? _messageSubscription;

//   // =========================
//   // Getters
//   // =========================

//   bool get isSending => _isSending;

//   String get errorMessage => _errorMessage;

//   String? get selectedUserId => _selectedUserId;

//   List<MessageModel> get activeMessages => _activeMessages;

//   // Current logged-in user's UID
//   String? get currentUserId => _auth.currentUser?.uid;

//   // =========================
//   // Select Chat
//   // =========================

//   Future<void> selectChat(String receiverId) async {
//     _selectedUserId = receiverId;

//     _activeMessages = [];

//     notifyListeners();

//     await _listenToMessages(receiverId);
//   }

//   // =========================
//   // Listen To Messages
//   // =========================

//   Future<void> _listenToMessages(String receiverId) async {
//     // Cancel previous chat listener
//     await _messageSubscription?.cancel();

//     final senderId = currentUserId;

//     if (senderId == null) {
//       _errorMessage = 'User is not logged in.';
//       notifyListeners();
//       return;
//     }

//     _messageSubscription = _chatServices
//         .getMessages(userId1: senderId, userId2: receiverId)
//         .listen(
//           (messages) {
//             _activeMessages = messages;

//             notifyListeners();

//             // Scroll after messages update
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               scrollToBottom();
//             });
//           },
//           onError: (error) {
//             _errorMessage = 'Failed to load messages.';
//             notifyListeners();
//           },
//         );
//   }

//   // =========================
//   // Send Message
//   // =========================

//   Future<bool> sendMessage() async {
//     final message = messageController.text.trim();

//     // Check message
//     if (message.isEmpty) {
//       _errorMessage = 'Please Enter a Message';
//       notifyListeners();
//       return false;
//     }

//     // Current logged-in user
//     final senderId = currentUserId;

//     // Currently selected receiver
//     final receiverId = _selectedUserId;

//     // Check login
//     if (senderId == null) {
//       _errorMessage = 'User is not logged in.';
//       notifyListeners();
//       return false;
//     }

//     // Check selected chat
//     if (receiverId == null) {
//       _errorMessage = 'No chat selected.';
//       notifyListeners();
//       return false;
//     }

//     try {
//       _isSending = true;
//       _errorMessage = '';

//       notifyListeners();

//       // Send message to Firebase
//       await _chatServices.sendMessage(
//         senderId: senderId,
//         receiverId: receiverId,
//         message: message,
//       );

//       // Clear input
//       messageController.clear();

//       return true;
//     } catch (e) {
//       _errorMessage = 'Failed to Send Message';

//       notifyListeners();

//       return false;
//     } finally {
//       _isSending = false;

//       notifyListeners();
//     }
//   }

//   // =========================
//   // Scroll To Bottom
//   // =========================

//   void scrollToBottom() {
//     if (!scrollController.hasClients) {
//       return;
//     }

//     scrollController.animateTo(
//       scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   // =========================
//   // Deselect Chat
//   // =========================

//   void deselectChat() {
//     _messageSubscription?.cancel();

//     _messageSubscription = null;

//     _selectedUserId = null;

//     _activeMessages = [];

//     messageController.clear();

//     notifyListeners();
//   }

//   // =========================
//   // Get Messages
//   // =========================

//   Stream<List<MessageModel>> getMessages({
//     required String userId1,
//     required String userId2,
//   }) {
//     return _chatServices.getMessages(userId1: userId1, userId2: userId2);
//   }

//   // =========================
//   // Clear Error
//   // =========================

//   void clearError() {
//     _errorMessage = '';

//     notifyListeners();
//   }

//   // =========================
//   // Dispose
//   // =========================

//   @override
//   void dispose() {
//     _messageSubscription?.cancel();

//     messageController.dispose();

//     scrollController.dispose();

//     super.dispose();
//   }
// }

import 'dart:async';

import 'package:chat_app/model/chat_thread_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier with WidgetsBindingObserver {
  final ChatServices _chatServices = ChatServices();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();

  // =========================
  // Controllers
  // =========================

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();

  // =========================
  // Sending State
  // =========================

  bool _isSending = false;

  String _errorMessage = '';

  // =========================
  // Selected Chat
  // =========================

  String? _selectedUserId;

  String _searchQuery = '';

  // =========================
  // Messages
  // =========================

  List<MessageModel> _activeMessages = [];

  StreamSubscription<List<MessageModel>>? _messageSubscription;

  // =========================
  // Chat Threads
  // =========================

  List<ChatThread> _chatThreads = [];

  StreamSubscription<List<ChatThread>>? _chatThreadsSubscription;

  // =========================
  // Getters
  // =========================

  bool get isSending => _isSending;

  String get errorMessage => _errorMessage;

  String? get selectedUserId => _selectedUserId;

  String get searchQuery => _searchQuery;

  List<MessageModel> get activeMessages => _activeMessages;

  List<ChatThread> get chatThreads => _chatThreads;

  // =========================
  // Current User ID
  // =========================

  String? get currentUserId => _auth.currentUser?.uid;

  // =========================
  // Active Chat Thread
  // =========================

  ChatThread? get activeChatThread {
    if (_selectedUserId == null) {
      return null;
    }

    try {
      return _chatThreads.firstWhere((thread) => thread.id == _selectedUserId);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // Initialize Chat Threads
  // =========================

  void listenToChatThreads() {
    final userId = currentUserId;

    if (userId == null) {
      _errorMessage = 'User is not logged in.';
      notifyListeners();
      return;
    }

    _chatThreadsSubscription?.cancel();

    _chatThreadsSubscription = _chatServices
        .getChatThreads(userId)
        .listen(
          (threads) {
            _chatThreads = threads;

            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'Failed to load conversations.';
            notifyListeners();
          },
        );
  }

  // =========================
  // Select Chat
  // =========================

  Future<void> selectChat(String receiverId) async {
    _selectedUserId = receiverId;

    _activeMessages = [];

    notifyListeners();

    final userId = currentUserId;
    if (userId != null) {
      await _chatServices.markChatAsRead(
        currentUserId: userId,
        otherUserId: receiverId,
      );

      // mark actual message as seen

      await _chatServices.markMessagesAsSeen(
        currentUserId: userId,
        otherUserId: receiverId,
      );
    }

    await _listenToMessages(receiverId);
  }

  // =========================
  // Listen To Messages
  // =========================

  Future<void> _listenToMessages(String receiverId) async {
    // Cancel previous listener
    await _messageSubscription?.cancel();

    final senderId = currentUserId;

    if (senderId == null) {
      _errorMessage = 'User is not logged in.';
      notifyListeners();
      return;
    }

    _messageSubscription = _chatServices
        .getMessages(userId1: senderId, userId2: receiverId)
        .listen(
          (messages) {
            _activeMessages = messages;

            notifyListeners();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToBottom();
            });
          },
          onError: (error) {
            _errorMessage = 'Failed to load messages.';
            notifyListeners();
          },
        );
  }

  // =========================
  // Send Message
  // =========================

  Future<bool> sendMessage() async {
    final message = messageController.text.trim();

    // Empty message
    if (message.isEmpty) {
      _errorMessage = 'Please Enter a Message';

      notifyListeners();

      return false;
    }

    // Current user
    final senderId = currentUserId;

    // Selected receiver
    final receiverId = _selectedUserId;

    // Login check
    if (senderId == null) {
      _errorMessage = 'User is not logged in.';

      notifyListeners();

      return false;
    }

    // Chat selection check
    if (receiverId == null) {
      _errorMessage = 'No chat selected.';

      notifyListeners();

      return false;
    }

    try {
      _isSending = true;

      _errorMessage = '';

      notifyListeners();

      // Send to Firebase
      await _chatServices.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );

      // Clear input
      messageController.clear();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to Send Message';

      notifyListeners();

      return false;
    } finally {
      _isSending = false;

      notifyListeners();
    }
  }

  // =========================
  // Scroll To Bottom
  // =========================

  void scrollToBottom() {
    if (!scrollController.hasClients) {
      return;
    }

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // =========================
  // Deselect Chat
  // =========================

  void deselectChat() {
    _messageSubscription?.cancel();

    _messageSubscription = null;

    _selectedUserId = null;

    _activeMessages = [];

    messageController.clear();

    notifyListeners();
  }

  // =========================
  // Get Messages
  // =========================

  Stream<List<MessageModel>> getMessages({
    required String userId1,
    required String userId2,
  }) {
    return _chatServices.getMessages(userId1: userId1, userId2: userId2);
  }

  // =========================
  // Search User Name
  // =========================

  void setSearchQuery(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  // =========================
  // OnlineStatus
  // =========================

  void initializeOnlineStaus() {
    WidgetsBinding.instance.addObserver(this);

    final userId = currentUserId;

    if (userId != null) {
      _setOnlineStatus(true);
    }
  }

  Future<void> _setOnlineStatus(bool isOnline) async {
    final userId = currentUserId;

    if (userId == null) return;

    try {
      await _firestoreServices.updateOnlineStatus(
        uid: userId,
        isOnline: isOnline,
      );
    } catch (e) {
      debugPrint('Online Status Update failed: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final userId = currentUserId;

    if (userId == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _setOnlineStatus(true);
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _setOnlineStatus(false);
        break;

      case AppLifecycleState.hidden:
        _setOnlineStatus(false);
        break;
    }
  }

  // =========================
  // Clear Error
  // =========================

  void clearError() {
    _errorMessage = '';

    notifyListeners();
  }

  // Clear Search

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  // =========================
  // Dispose
  // =========================

  @override
  void dispose() {
    _messageSubscription?.cancel();

    _chatThreadsSubscription?.cancel();

    messageController.dispose();

    scrollController.dispose();

    searchController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
