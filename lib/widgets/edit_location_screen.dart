import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edit_location/location_bloc.dart';
import '../bloc/services/location_service.dart';
import 'edit_location_from.dart';

class EditLocationScreen extends StatelessWidget {
  final String initialValue;
  final int mode;

  const EditLocationScreen(
      {super.key, required this.initialValue, required this.mode});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: initialValue);
    final service = LocationService();

    return BlocProvider(
      create: (_) => LocationBloc(service),
      child: Scaffold(
        appBar: AppBar(title: Text("Edit Location")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EditLocationFrom(initialValue: initialValue, mode:mode),
        ),
      ),
    );
  }
}
