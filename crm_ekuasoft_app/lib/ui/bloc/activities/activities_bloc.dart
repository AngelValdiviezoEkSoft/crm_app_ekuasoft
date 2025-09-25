import 'package:bloc/bloc.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  
  List<DatumActivitiesResponse> lstActivities = [];

  ActivitiesBloc() : super(ActivitiesState(lstActivities: [],)) {
    on<OnLstActivities>(_onInitLst);     
  }

  void _onInitLst( OnLstActivities event, Emitter<ActivitiesState> emit ) {
    emit( state.copyWith( lstActivities: lstActivities ) );
  }

  void setLstActividades(List<DatumActivitiesResponse> lst) {
    lstActivities = lst;
    add(OnLstActivities(lst));
  }

}
