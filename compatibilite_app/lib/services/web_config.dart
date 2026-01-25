@JS()
library web_config;

import 'dart:js_interop';

/// Access window.flutterConfig from JavaScript
@JS('window.flutterConfig')
external JSObject? get _flutterConfig;

/// Get a configuration value from window.flutterConfig
String getWebConfigValue(String key) {
  try {
    final config = _flutterConfig;
    if (config == null) return '';
    
    // Use dynamic access to get the property
    final value = config.getProperty(key.toJS);
    if (value == null) return '';
    
    return (value as JSString).toDart;
  } catch (e) {
    return '';
  }
}

extension on JSObject {
  external JSAny? getProperty(JSString key);
}
