abstract class AppEvent {}

class FetchEvent extends AppEvent {
  final dynamic region;

  FetchEvent({this.region});
}
