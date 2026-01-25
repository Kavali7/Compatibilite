/// Web-specific URL launcher that opens URLs in a popup window
/// This file uses dart:html and should only be imported on web platform

import 'dart:html' as html;

/// Store reference to the popup window so we can close it later
html.WindowBase? _currentPopup;

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
    
    // Store reference to close later
    _currentPopup = popup;
    
    // Check if popup was blocked
    if (popup == null) {
      // Fallback: open in new tab
      _currentPopup = html.window.open(url, '_blank');
      return true;
    }
    
    return true;
  } catch (e) {
    return false;
  }
}

/// Close the popup and focus the main window
void closePaymentPopup() {
  try {
    // Try to close the popup
    if (_currentPopup != null) {
      _currentPopup!.close();
      _currentPopup = null;
    }
    
    // Focus the main window
    html.window.focus();
  } catch (e) {
    // Ignore errors - popup might have been closed by user
  }
}

/// Check if the popup is still open
bool isPopupOpen() {
  try {
    if (_currentPopup == null) return false;
    // Can't reliably check closed property on WindowBase
    return true;
  } catch (e) {
    return false;
  }
}
