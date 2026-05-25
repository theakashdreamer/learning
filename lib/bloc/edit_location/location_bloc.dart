import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/google_location.dart';
import '../services/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService service;

  LocationBloc(this.service) : super(LocationInitial()) {
    on<LocationInputChanged>((event, emit) async {
      if (event.input.isEmpty) {
        emit(LocationInitial());
        return;
      }
      emit(LocationLoading());
      try {
        // Mock JSON data (replace with API call)
        final data = await LocationService.getSuggestions(event.input);
        // final data = '''[{"description":"Gol Market Chowraha, Mahanagar, Lucknow, Uttar Pradesh, India","matched_substrings":[{"length":7,"offset":0}],"place_id":"Ej1Hb2wgTWFya2V0IENob3dyYWhhLCBNYWhhbmFnYXIsIEx1Y2tub3csIFV0dGFyIFByYWRlc2gsIEluZGlhIi4qLAoUChIJqQcrlmX9mzkRlAR6pc8lhfkSFAoSCWuxMh-Z_Zs5EeeLlwmJusyT","reference":"Ej1Hb2wgTWFya2V0IENob3dyYWhhLCBNYWhhbmFnYXIsIEx1Y2tub3csIFV0dGFyIFByYWRlc2gsIEluZGlhIi4qLAoUChIJqQcrlmX9mzkRlAR6pc8lhfkSFAoSCWuxMh-Z_Zs5EeeLlwmJusyT","structured_formatting":{"main_text":"Gol Market Chowraha","main_text_matched_substrings":[{"length":7,"offset":0}],"secondary_text":"Mahanagar, Lucknow, Uttar Pradesh, India"},"terms":[{"offset":0,"value":"Gol Market Chowraha"},{"offset":21,"value":"Mahanagar"},{"offset":32,"value":"Lucknow"},{"offset":41,"value":"Uttar Pradesh"},{"offset":56,"value":"India"}],"types":["geocode","route"]},{"description":"Gole Market, New Delhi, Delhi, India","matched_substrings":[{"length":11,"offset":0}],"place_id":"ChIJKaqllFr9DDkR9YNulsdRItQ","reference":"ChIJKaqllFr9DDkR9YNulsdRItQ","structured_formatting":{"main_text":"Gole Market","main_text_matched_substrings":[{"length":11,"offset":0}],"secondary_text":"New Delhi, Delhi, India"},"terms":[{"offset":0,"value":"Gole Market"},{"offset":13,"value":"New Delhi"},{"offset":24,"value":"Delhi"},{"offset":31,"value":"India"}],"types":["geocode","political","sublocality","sublocality_level_1"]},{"description":"Gol Market, F-7/3 F 7/3 F-7, Islamabad, Pakistan","matched_substrings":[{"length":7,"offset":0}],"place_id":"ChIJ78tQegm_3zgRmRdPDO0d3TU","reference":"ChIJ78tQegm_3zgRmRdPDO0d3TU","structured_formatting":{"main_text":"Gol Market","main_text_matched_substrings":[{"length":7,"offset":0}],"secondary_text":"F-7/3 F 7/3 F-7, Islamabad, Pakistan"},"terms":[{"offset":0,"value":"Gol Market"},{"offset":12,"value":"F-7/3"},{"offset":18,"value":"F 7/3"},{"offset":24,"value":"F-7"},{"offset":29,"value":"Islamabad"},{"offset":40,"value":"Pakistan"}],"types":["geocode","premise"]},{"description":"Gol Market, Sector X Sector Y DHA Phase 3, Lahore, Pakistan","matched_substrings":[{"length":7,"offset":0}],"place_id":"ChIJzX8ET3cGGTkR59nQLZygL94","reference":"ChIJzX8ET3cGGTkR59nQLZygL94","structured_formatting":{"main_text":"Gol Market","main_text_matched_substrings":[{"length":7,"offset":0}],"secondary_text":"Sector X Sector Y DHA Phase 3, Lahore, Pakistan"},"terms":[{"offset":0,"value":"Gol Market"},{"offset":12,"value":"Sector X"},{"offset":21,"value":"Sector Y"},{"offset":30,"value":"DHA Phase 3"},{"offset":43,"value":"Lahore"},{"offset":51,"value":"Pakistan"}],"types":["geocode","premise"]},{"description":"Gölmarmara, Manisa, Türkiye","matched_substrings":[{"length":10,"offset":0}],"place_id":"ChIJEWibCEq1uRQRTt-Qx9LWJz8","reference":"ChIJEWibCEq1uRQRTt-Qx9LWJz8","structured_formatting":{"main_text":"Gölmarmara","main_text_matched_substrings":[{"length":10,"offset":0}],"secondary_text":"Manisa, Türkiye"},"terms":[{"offset":0,"value":"Gölmarmara"},{"offset":12,"value":"Manisa"},{"offset":20,"value":"Türkiye"}],"types":["geocode","locality","political"]}]''';
        final suggestions = data
            .map((p) => GoogleLocation.named(
                  placeId: p['place_id'],
                  areaDetails: p['description'],
                ))
            .toList();
        // final suggestions =data;
        emit(LocationLoaded(suggestions));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
    on<LocationSelected>(_onLocationSelected);
    on<FetchCurrentLocation>(_onLFetchCurrentLocation);
  }

  Future<void> _onLocationSelected(
      LocationSelected event, Emitter<LocationState> emit) async {
    try {
      final String apiKey = "AIzaSyBew8_tTpCWn4PrXTpra_besUQyr8lLZVs";
      final placeId = event.location.placeId;
      final url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != 'OK') {
          emit(LocationError(data['error_message'] ?? "Place details failed"));
          return;
        }
        final result = data['result'];
        if (result == null || result['geometry'] == null) {
          emit(LocationError("Invalid location data"));
          return;
        }
        final loc = result['geometry']['location'];
        final position = LatLng(loc['lat'], loc['lng']);
        final updatedLocation = event.location.copyWith(position: position);
        emit(LocationSelectedState(updatedLocation));
      } else {
        emit(LocationError("Failed to fetch place details"));
      }
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  FutureOr<void> _onLFetchCurrentLocation(
      FetchCurrentLocation event, Emitter<LocationState> emit) {
    emit(LocationSelectedState(event.location));
  }
}
