import '../../models/google_location.dart';

abstract class LocationEvent {}

class LocationInputChanged extends LocationEvent {
  final String input;

  LocationInputChanged(this.input);
}

class LocationSelected extends LocationEvent {
  final GoogleLocation location;

  LocationSelected(this.location);
}

class FetchCurrentLocation extends LocationEvent {
  final GoogleLocation location;

  FetchCurrentLocation(this.location);
}
