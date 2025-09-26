part of 'activities_bloc.dart';

class ActivitiesState extends Equatable {
  final List<DatumActivitiesResponse> lstActivities;
  final List<DatumActivitiesResponse> lstActivitiesResp;

  const ActivitiesState({
    required this.lstActivities,
    required this.lstActivitiesResp,
  });

  ActivitiesState copyWith ({
    List<DatumActivitiesResponse>? lstActivities,
    List<DatumActivitiesResponse>? lstActivitiesResp,
  }) => ActivitiesState(
    lstActivities: lstActivities ?? this.lstActivities,
    lstActivitiesResp: lstActivitiesResp ?? this.lstActivitiesResp
  );
  
  @override
  List<Object> get props => [lstActivities, lstActivitiesResp];
}

