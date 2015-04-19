#import <WebKit/WebKit.h>

#import "ITProgressIndicator.h"

#import "TVView.h"

@interface TVAuthorizationView : TVView {
 @private
  ITProgressIndicator *_progressIndicator;
  WebView *_webView;
  BOOL _success;
}

@end
