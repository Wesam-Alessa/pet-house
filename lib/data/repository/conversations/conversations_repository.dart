import 'package:pet_house/domain/entities/conversation/messaging/send_message.dart';
import 'package:pet_house/domain/entities/conversation/messaging/received_message.dart';
import 'package:pet_house/domain/entities/conversation/chat/initial_chat.dart';
import 'package:pet_house/domain/entities/conversation/chat/get_chat.dart';
import 'package:pet_house/domain/entities/conversation/chat/create_chat.dart';
import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../datasource/conversations/conversations_remote_data_source.dart';

class ConversationsRepository extends BaseConversationRepository {
  final BaseConversationsRemoteDataSource baseConversationsRemoteDataSource;
  ConversationsRepository(this.baseConversationsRemoteDataSource);

  @override
  Future<Either<Failure, GetChatModel>> accessChat(CreateChatModel parameters) async{
    final result = await baseConversationsRemoteDataSource.accessChat(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<GetChatModel>>> getChat() async{
    final result = await baseConversationsRemoteDataSource.getChat();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<ReceivedMessageModel>>> getMessages(InitialChatModel parameters) async{
    final result = await baseConversationsRemoteDataSource.getMessages(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, ReceivedMessageModel>> sendMessage(SendMessageModel parameters) async{
    final result = await baseConversationsRemoteDataSource.sendMessage(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
