@HtmlImport('option_toggle.html')
library option_toggle;

import 'dart:html';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

@PolymerRegister('option-toggle')
class OptionToggle extends PolymerElement {
  OptionToggle.created() : super.created();

  var log = new Logger('$OptionToggle');

  @Property(notify: true)
  bool value;

  @property
  String label;

  @property
  String shortcut;

}