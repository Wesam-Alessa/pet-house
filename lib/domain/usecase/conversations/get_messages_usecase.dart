import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/domain/entities/conversation/chat/initial_chat.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/conversation/messaging/received_message.dart';

class GetMessagesUsecase extends BaseUseCase<List<ReceivedMessageModel>,InitialChatModel>{
  final BaseConversationRepository baseConversationRepository;
  GetMessagesUsecase(this.baseConversationRepository);

  @override
  Future<Either<Failure, List<ReceivedMessageModel>>> call(InitialChatModel parameters) async{
    return await baseConversationRepository.getMessages(parameters);
  } 
}