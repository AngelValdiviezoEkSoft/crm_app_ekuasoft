import 'package:bloc/bloc.dart';
import 'package:crm_ekuasoft_app/domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  
  List<DatumActivitiesResponse> lstActivities = [];
  List<DatumActivitiesResponse> lstActivitiesResp = [];

  ActivitiesBloc() : super(const ActivitiesState(lstActivities: [], lstActivitiesResp: [])) {
    on<OnLstActivities>(_onInitLst);
    on<OnLstActivitiesRespaldo>(_onInitLstResp);
  }

  void _onInitLst( OnLstActivities event, Emitter<ActivitiesState> emit ) {
    emit( state.copyWith( lstActivities: lstActivities ) );
  }

  void _onInitLstResp( OnLstActivitiesRespaldo event, Emitter<ActivitiesState> emit ) {
    emit( state.copyWith( lstActivitiesResp: lstActivitiesResp ) );
  }

  void setLstActividades(List<DatumActivitiesResponse> lst) {
    lstActivities = lst;
    add(OnLstActivities(lst));
  }

  void setLstActividadesResp(List<DatumActivitiesResponse> lst) {
    lstActivitiesResp = lst;
    add(OnLstActivitiesRespaldo(lst));
  }

}
