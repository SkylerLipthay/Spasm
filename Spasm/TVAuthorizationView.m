#import "TVAPI.h"

#import "TVAuthorizationView.h"

@implementation TVAuthorizationView

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  _progressIndicator = [[ITProgressIndicator alloc] init];
  [self addSubview:_progressIndicator];

  _webView = [[WebView alloc] init];
  [_webView setHidden:YES];
  [_webView setResourceLoadDelegate:self];
  [_webView setPolicyDelegate:self];
  [[_webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[TVAPI authorizationURL]]];
  [self addSubview:_webView];

  return self;
}

- (void)viewResized {
  NSRect frame = _progressIndicator.frame;
  frame.origin.x = (self.bounds.size.width - _progressIndicator.bounds.size.width) / 2;
  frame.origin.y = (self.bounds.size.height - _progressIndicator.bounds.size.height) / 2;
  _progressIndicator.frame = frame;

  _webView.frame = self.bounds;
}

- (BOOL)drawsBackground {
  return _webView.isHidden;
}

- (void)webView:(WebView *)sender resource:(id)identifier didReceiveResponse:(NSURLResponse *)response fromDataSource:(WebDataSource *)dataSource {
  if (!_success && [(NSHTTPURLResponse *)response statusCode] == 500) {
    [[_webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[TVAPI authorizationURL]]];
    return;
  }

  _success = YES;
  NSScrollView *scrollView = sender.mainFrame.frameView.documentView.enclosingScrollView;
  [scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
  [scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];

  [_progressIndicator setHidden:YES];
  [sender setHidden:NO];
  [self setNeedsDisplay:YES];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
  if ([request.URL.scheme isEqualToString:@"spasm"]) {
    NSDictionary *parameters = [TVAPI URLQueryParameters:request.URL];
    [self.stateController authorizedWithCode:[parameters objectForKey:@"access_token"]];
    [listener ignore];
    return;
  }

  [listener use];
}

@end
