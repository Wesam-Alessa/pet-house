

import 'package:pet_house/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/conversation/chat/create_chat.dart';
import '../../entities/conversation/chat/get_chat.dart';
import '../../entities/conversation/chat/initial_chat.dart';
import '../../entities/conversation/messaging/received_message.dart';
import '../../entities/conversation/messaging/send_message.dart';

abstract class BaseConversationRepository{
  Future<Either<Failure,GetChatModel>> accessChat(CreateChatModel parameters);
  Future<Either<Failure,List<GetChatModel>>> getChat();
  Future<Either<Failure,ReceivedMessageModel>> sendMessage(SendMessageModel parameters);
  Future<Either<Failure,List<ReceivedMessageModel>>> getMessages(InitialChatModel parameters);
}