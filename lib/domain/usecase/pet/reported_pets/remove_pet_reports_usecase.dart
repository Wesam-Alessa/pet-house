import 'package:pet_house/core/error/failure.dart';
import 'package:pet_house/core/network/success_message_model.dart';
import 'package:pet_house/core/usecase/base_usecase.dart';
import 'package:pet_house/data/models/parameters/remove_pet_reports_parameters.dart';
import 'package:pet_house/domain/repository/pet/base_pet_repository.dart';
import 'package:dartz/dartz.dart';

class RemovePetReportsUseCase extends BaseUseCase<SuccessMessageModel, RemovePetReportsParameters> {
  final BasePetRepository basePetRepository;

  RemovePetReportsUseCase(this.basePetRepository);
  
  @override
  Future<Either<Failure, SuccessMessageModel>> call(RemovePetReportsParameters parameters)async {
     return await basePetRepository.removePetReports(parameters);
  }
}