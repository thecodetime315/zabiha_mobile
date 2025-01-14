import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../location_model/location_model.dart';


part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  onLocationUpdated(LocationModel model,{bool? change}){
    // emit(LocationUpdated(model, state.changed));
    emit(LocationLoading());
    emit(LocationUpdated(model, change));
  }

}
