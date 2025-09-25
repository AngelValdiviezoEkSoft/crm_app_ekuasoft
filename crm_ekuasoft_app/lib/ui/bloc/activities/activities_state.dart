part of 'activities_bloc.dart';

class ActivitiesState extends Equatable {
  final List<DatumActivitiesResponse> lstActivities;

  const ActivitiesState({
    required this.lstActivities,
  });

  ActivitiesState copyWith ({
    List<DatumActivitiesResponse>? lstActivities,
  }) => ActivitiesState(
    lstActivities: lstActivities ?? this.lstActivities
  );
  
  @override
  List<Object> get props => [lstActivities];
}

