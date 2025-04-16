import 'package:crm_ekuasoft_app/domain/domain.dart';

class ActivitiesPageModel {
  ActivitiesResponseModel activities;
  DatumCrmLead lead;
  MailActivityTypeAppModel objMailAct;

  ActivitiesPageModel(
    {
      required this.activities,
      required this.lead,
      required this.objMailAct
    }
  );

}