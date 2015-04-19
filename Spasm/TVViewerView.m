#import "UNIRest.h"

#import "TVTab.h"
#import "TVTabContents.h"
#import "TVAPI.h"
#import "TVImageManager.h"

#import "TVViewerView.h"

@implementation TVViewerView

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  _tabsContainer = [[TVTabsContainer alloc] init];
  _tabsContainer.delegate = self;
  [self addSubview:_tabsContainer];
  [self newTab:self];

  return self;
}

- (void)setCode:(NSString *)code {
  _code = [code copy];

  [_refreshTimer invalidate];
  _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refreshStreams)
                                                 userInfo:nil repeats:YES];
  [_refreshTimer fire];
}

- (void)refreshStreams {
  NSDictionary *headers = @{ @"Accept": @"application/vnd.twitchtv.v2+json",
                             @"Authorization": [NSString stringWithFormat:@"OAuth %@", _code] };

  NSMutableArray *streams = [[NSMutableArray alloc] init];
  NSUInteger offset = 0;

  for (;;) {
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest* request) {
      [request setUrl:[[TVAPI streamListURLWithOffset:offset] absoluteString]];
      [request setHeaders:headers];
    }] asJson];

    NSArray *localStreams = [response.body.JSONObject objectForKey:@"streams"];
    [streams addObjectsFromArray:localStreams];

    if (localStreams.count < 100) {
      break;
    }

    offset += 100;
  }

  [[TVImageManager shared] clear];
  _streams = streams;

  for (NSView *view in self.subviews) {
    if (![view isKindOfClass:[TVTabContents class]]) {
      continue;
    }

    TVTabContents *tabContents = (TVTabContents *)view;
    tabContents.streams = streams;
  }
}

- (void)viewResized {
  _tabsContainer.frame = NSMakeRect(0, 0, self.bounds.size.width, _tabsContainer.bounds.size.height);

  for (NSView *view in self.subviews) {
    if (![view isKindOfClass:[TVTabContents class]]) {
      continue;
    }

    [self positionTabContents:view];
  }
}

- (void)positionTabContents:(NSView *)view {
  if (_maximizedStream) {
    view.frame = self.bounds;
  } else {
    view.frame = NSMakeRect(0, 24, self.bounds.size.width, self.bounds.size.height - 24);
  }
}

- (void)closeActiveTab:(id)sender {
  [_tabsContainer closeActiveTab];
}

- (void)tabsContainerDidEmpty:(TVTabsContainer *)tabsContainer {
  [self newTab:self];
}

- (void)tabsContainerWantsNewTab:(TVTabsContainer *)tabsContainer {
  [self newTab:self];
}

- (void)newTab:(id)sender {
  TVTab *tab = [[TVTab alloc] init];
  tab.title = @"New Tab";
  tab.view = [[TVTabContents alloc] init];
  tab.view.streams = _streams;
  if (_maximizedStream) {
    [tab.view maximizeStream];
  }
  [self positionTabContents:tab.view];
  [self addSubview:tab.view];
  [_tabsContainer addTab:tab];
}

- (void)nextTab:(id)sender {
  [_tabsContainer nextTab];
}

- (void)previousTab:(id)sender {
  [_tabsContainer previousTab];
}

- (void)maximizeStream:(id)sender {
  _maximizedStream = !_maximizedStream;
  [_tabsContainer setHidden:_maximizedStream];
  [self viewResized];

  for (NSView *view in self.subviews) {
    if (![view isKindOfClass:[TVTabContents class]]) {
      continue;
    }

    TVTabContents *contents = (TVTabContents *)view;
    if (_maximizedStream) {
      [contents maximizeStream];
    } else {
      [contents minimizeStream];
    }
  }
}

@end
