part of 'activities_bloc.dart';

sealed class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class OnLstActivities extends ActivitiesEvent {
  final List<DatumActivitiesResponse> lstActivities;
  const OnLstActivities(this.lstActivities);
}

class OnLstActivitiesRespaldo extends ActivitiesEvent {
  final List<DatumActivitiesResponse> lstActivities;
  const OnLstActivitiesRespaldo(this.lstActivities);
}