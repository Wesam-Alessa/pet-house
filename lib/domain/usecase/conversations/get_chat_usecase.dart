import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/no_parameters.dart';
import 'package:pet_house/domain/repository/conversations/base_conversation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../entities/conversation/chat/get_chat.dart';

class GetChatUsecase extends BaseUseCase<List<GetChatModel>,NoParameters>{
  final BaseConversationRepository baseConversationRepository;
  GetChatUsecase(this.baseConversationRepository);

  @override
  Future<Either<Failure, List<GetChatModel>>> call(NoParameters parameters) async{
    return await baseConversationRepository.getChat();
  } 
}