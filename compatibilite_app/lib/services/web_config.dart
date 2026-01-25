@JS()
library web_config;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Access window.flutterConfig from JavaScript
@JS('window.flutterConfig')
external JSObject? get _flutterConfig;

/// Get a configuration value from window.flutterConfig
String getWebConfigValue(String key) {
  try {
    final config = _flutterConfig;
    if (config == null) {
      return '';
    }
    
    // Use js_interop_unsafe for property access
    final value = config[key];
    if (value == null) return '';
    
    // Convert to Dart string
    if (value.isA<JSString>()) {
      return (value as JSString).toDart;
    }
    
    // Fallback: try to convert to string
    return value.toString();
  } catch (e) {
    return '';
  }
}
