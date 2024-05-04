import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/domain/entities/conversation/messaging/send_message.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/conversation/messaging/received_message.dart';

class SendMessagesUsecase extends BaseUseCase<ReceivedMessageModel,SendMessageModel>{
  final BaseConversationRepository baseConversationRepository;
  SendMessagesUsecase(this.baseConversationRepository);

  @override
  Future<Either<Failure, ReceivedMessageModel>> call(SendMessageModel parameters) async{
    return await baseConversationRepository.sendMessage(parameters);
  } 
}