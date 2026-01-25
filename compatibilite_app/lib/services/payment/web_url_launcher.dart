/// Web-specific URL launcher that opens URLs in a popup window
/// This file uses dart:html and should only be imported on web platform

import 'dart:html' as html;

/// Open a URL in a popup window (not a new tab or redirect)
/// Returns true if the popup was opened successfully
bool openUrlInPopup(String url, {String windowName = 'FedaPayPayment'}) {
  try {
    // Open in a centered popup window
    const width = 500;
    const height = 700;
    final left = (html.window.screen?.width ?? 1024) ~/ 2 - width ~/ 2;
    final top = (html.window.screen?.height ?? 768) ~/ 2 - height ~/ 2;
    
    final features = 'width=$width,height=$height,left=$left,top=$top,'
        'scrollbars=yes,resizable=yes,status=yes,location=yes';
    
    final popup = html.window.open(url, windowName, features);
    
    // Check if popup was blocked
    if (popup == null) {
      // Fallback: open in new tab
      html.window.open(url, '_blank');
      return true;
    }
    
    return true;
  } catch (e) {
    return false;
  }
}
