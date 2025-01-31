import 'package:base_flutter/features/repos/base_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/home_model.dart';
import '../../../../repos/repo_impl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  BaseRepo homeRepo = RepoImpl();
  getHome() async{
    emit(HomeLoading());
    var result = await homeRepo.home();
    if(result.isNotEmpty){
      emit(HomeSuccess(result));
    }else{
      emit(HomeFailed());
    }
  }
}
