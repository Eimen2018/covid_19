import 'package:auto_route/auto_route_annotations.dart';
import 'package:covid_19/ui/views/home/home_view.dart';
import 'package:covid_19/ui/views/info/info_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeView;
  InfoView infoViewRoute;
}
