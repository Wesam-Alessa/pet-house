import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/conversation/chat/create_chat.dart';
import '../../entities/conversation/chat/get_chat.dart';

class AccessChatUsecase extends BaseUseCase<GetChatModel,CreateChatModel>{
  final BaseConversationRepository baseConversationRepository;
  AccessChatUsecase(this.baseConversationRepository);

  @override
  Future<Either<Failure, GetChatModel>> call(CreateChatModel parameters) async{
    return await baseConversationRepository.accessChat(parameters);
  } 
}