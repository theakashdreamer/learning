import '../../models/google_location.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<GoogleLocation> suggestions;
  LocationLoaded(this.suggestions);
}

class LocationSelectedState extends LocationState {
  final GoogleLocation selected;
  LocationSelectedState(this.selected);
}


class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
