library vocal_coach.app;

import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'elements/root_app/root_app.dart';

/// Using [RootApp]
start() async {

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(print);

  await initPolymer();
}