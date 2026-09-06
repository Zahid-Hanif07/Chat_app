import 'package:chat_app/model/chat_thread_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirestoreServices _firestoreServices = FirestoreServices();

  // =========================================================
  // Generate Same Chat Room ID For Both Users
  // =========================================================

  String _getChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2];

    ids.sort();

    return ids.join('_');
  }

  // =========================================================
  // Send Message
  // =========================================================

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    String type = 'text',
  }) async {
    final chatRoomId = _getChatRoomId(senderId, receiverId);

    // -------------------------------------------------------
    // Create message document
    // -------------------------------------------------------

    final docRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc();

    final timestamp = Timestamp.now();

    final messageModel = MessageModel(
      messageId: docRef.id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      type: type,
    );

    // -------------------------------------------------------
    // Update chat summary + unread count
    // -------------------------------------------------------

    final chatRef = _firestore.collection('chats').doc(chatRoomId);

    await _firestore.runTransaction((transaction) async {
      final chatSnapshot = await transaction.get(chatRef);

      if (!chatSnapshot.exists) {
        // First message in this conversation

        transaction.set(chatRef, {
          'participants': [senderId, receiverId],
          'lastMessage': message,
          'lastMessageTime': timestamp,

          'unreadCounts': {senderId: 0, receiverId: 1},
        });
      } else {
        // Existing conversation

        final data = chatSnapshot.data() ?? {};

        final unreadCounts = Map<String, dynamic>.from(
          data['unreadCounts'] ?? {},
        );

        final currentUnread = (unreadCounts[receiverId] ?? 0) as num;

        unreadCounts[receiverId] = currentUnread.toInt() + 1;

        // Sender's unread count should exist
        unreadCounts.putIfAbsent(senderId, () => 0);

        transaction.update(chatRef, {
          'participants': [senderId, receiverId],
          'lastMessage': message,
          'lastMessageTime': timestamp,
          'unreadCounts': unreadCounts,
        });
      }
    });

    // -------------------------------------------------------
    // Save actual message
    // -------------------------------------------------------

    await docRef.set(messageModel.toJson());
  }

  // =========================================================
  // Mark Chat As Read
  // =========================================================

  Future<void> markChatAsRead({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final chatRoomId = _getChatRoomId(currentUserId, otherUserId);

    final chatRef = _firestore.collection('chats').doc(chatRoomId);

    try {
      await chatRef.update({'unreadCounts.$currentUserId': 0});
    } catch (e) {
      // Chat may not exist yet
      // or there may be no unread field.
      return;
    }
  }

  // =========================================================
  // Get Messages
  // =========================================================

  Stream<List<MessageModel>> getMessages({
    required String userId1,
    required String userId2,
  }) {
    final chatRoomId = _getChatRoomId(userId1, userId2);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList();
        });
  }

  // =========================================================
  // Mark Message As Seen
  // =========================================================

  Future<void> markMessagesAsSeen({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final chatRoomId = _getChatRoomId(currentUserId, otherUserId);

    final messagesRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages');

    try {
      final snapshot = await messagesRef
          .where('receiverId', isEqualTo: currentUserId)
          .where('isSeen', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isSeen': true});
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Mark messages as seen failed: $e');
    }
  }

  // =========================================================
  // Get Existing Chat Threads
  // =========================================================

  Stream<List<ChatThread>> getChatThreads(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<ChatThread> threads = [];

          for (final chatDoc in snapshot.docs) {
            final data = chatDoc.data();

            // -------------------------------------------------
            // Participants
            // -------------------------------------------------

            final participants = List<String>.from(data['participants'] ?? []);

            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
              orElse: () => '',
            );

            if (otherUserId.isEmpty) {
              continue;
            }

            // -------------------------------------------------
            // Get Other User
            // -------------------------------------------------

            final user = await _firestoreServices.getUser(otherUserId);

            if (user == null) {
              continue;
            }

            // -------------------------------------------------
            // Last Message
            // -------------------------------------------------

            String lastMessage = '';

            if (data['lastMessage'] != null) {
              lastMessage = data['lastMessage'].toString();
            }

            // -------------------------------------------------
            // Last Message Time
            // -------------------------------------------------

            DateTime? lastMessageTime;

            final timestamp = data['lastMessageTime'];

            if (timestamp is Timestamp) {
              lastMessageTime = timestamp.toDate();
            }

            // -------------------------------------------------
            // Unread Count
            // -------------------------------------------------

            int unreadCount = 0;

            final unreadData = data['unreadCounts'];

            if (unreadData is Map) {
              final value = unreadData[currentUserId];

              if (value is num) {
                unreadCount = value.toInt();
              }
            }

            // -------------------------------------------------
            // Create Chat Thread
            // -------------------------------------------------

            threads.add(
              ChatThread(
                id: user.uid,
                name: user.name,
                avatarUrl: user.imageUrl ?? '',
                isOnline: user.isOnline,
                lastMessage: lastMessage,
                lastMessageTime: lastMessageTime,
                unreadCount: unreadCount,
              ),
            );
          }

          // ---------------------------------------------------
          // Sort Latest Chat First
          // ---------------------------------------------------

          threads.sort((a, b) {
            if (a.lastMessageTime == null && b.lastMessageTime == null) {
              return a.name.toLowerCase().compareTo(b.name.toLowerCase());
            }

            if (a.lastMessageTime == null) {
              return 1;
            }

            if (b.lastMessageTime == null) {
              return -1;
            }

            return b.lastMessageTime!.compareTo(a.lastMessageTime!);
          });

          return threads;
        });
  }
}
