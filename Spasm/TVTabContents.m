#import "TVStreamCellView.h"
#import "TVStreamHeaderView.h"
#import "TVTab.h"
#import "TVAPI.h"
#import "TVAdBlocker.h"

#import "TVTabContents.h"

@implementation TVTabContents

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  [self setHidden:YES];

  _gridView = [[JNWCollectionView alloc] init];
  JNWCollectionViewGridLayout *gridLayout = [[JNWCollectionViewGridLayout alloc] init];
	gridLayout.delegate = self;
  gridLayout.itemPaddingEnabled = NO;
	_gridView.collectionViewLayout = gridLayout;
  _gridView.delegate = self;
	_gridView.dataSource = self;
  _gridView.drawsBackground = NO;
  _gridView.animatesSelection = NO;
	[_gridView registerClass:TVStreamCellView.class forCellWithReuseIdentifier:[self cellIdentifier]];

  NSString *kind = JNWCollectionViewGridLayoutHeaderKind;
  [_gridView registerClass:TVStreamHeaderView.class forSupplementaryViewOfKind:kind
       withReuseIdentifier:[self headerIdentifier]];
  kind = JNWCollectionViewGridLayoutFooterKind;
  [_gridView registerClass:TVStreamFooterView.class forSupplementaryViewOfKind:kind
       withReuseIdentifier:[self footerIdentifier]];


  [_gridView reloadData];
  [self addSubview:_gridView];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(viewResized)
                                               name:NSViewFrameDidChangeNotification
                                             object:self];

  return self;
}

- (NSString *)cellIdentifier {
  return [NSString stringWithFormat:@"streamcell-%p", self];
}

- (NSString *)headerIdentifier {
  return [NSString stringWithFormat:@"streamheader-%p", self];
}

- (NSString *)footerIdentifier {
  return [NSString stringWithFormat:@"streamfooter-%p", self];
}

- (void)teardown {
  _streamView.resourceLoadDelegate = nil;
  if ([_streamView isLoading]) {
    [_streamView stopLoading:self];
  }
  [[_streamView mainFrame] loadHTMLString:@"" baseURL:nil];
  [_streamView removeFromSuperview];

  _chatView.policyDelegate = nil;
  if ([_chatView isLoading]) {
    [_chatView stopLoading:self];
  }
  [[_chatView mainFrame] loadHTMLString:@"" baseURL:nil];
  [_chatView removeFromSuperview];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewResized {
  _gridView.frame = self.bounds;
  _chatView.frame = NSMakeRect(self.bounds.size.width - 300, 0, 300, self.bounds.size.height);
  if (_maximizedStream) {
    _streamView.frame = self.bounds;
  } else {
    _streamView.frame = NSMakeRect(0, 0, _chatView.frame.origin.x, self.bounds.size.height);
  }
}

- (void)setStreams:(NSArray *)streams {
  if (_gridView == nil) {
    return;
  }

  _streams = [streams copy];
  [_gridView reloadData];
}

#pragma mark Data source

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSString *ident = [self cellIdentifier];
	TVStreamCellView *cell = (TVStreamCellView *)[collectionView dequeueReusableCellWithIdentifier:ident];

  if ([indexPath length] == 0) {
    return cell;
  }

  NSUInteger index = indexPath.jnw_item;
  if (index >= _streams.count) {
    return cell;
  }

  NSDictionary *stream = [_streams objectAtIndex:index];
  [cell setStream:stream];
  [[self window] invalidateCursorRectsForView:cell];

	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView {
	return 1;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_streams count];
}

- (CGSize)sizeForItemInCollectionView:(JNWCollectionView *)collectionView {
	return CGSizeMake(260, 180);
}

- (JNWCollectionViewReusableView *)collectionView:(JNWCollectionView *)collectionView viewForSupplementaryViewOfKind:(NSString *)kind inSection:(NSInteger)section {
  if ([kind compare:JNWCollectionViewGridLayoutFooterKind] == NSOrderedSame) {
    TVStreamFooterView *footer = (TVStreamFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifer:[self footerIdentifier]];
    footer.delegate = self;
    return footer;
  } else if ([kind compare:JNWCollectionViewGridLayoutHeaderKind] == NSOrderedSame) {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifer:[self headerIdentifier]];
  }

  return nil;
}

- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForHeaderInSection:(NSInteger)index {
  return 39;
}

- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForFooterInSection:(NSInteger)index {
  return 69;
}

- (void)collectionView:(JNWCollectionView *)collectionView mouseUpInItemAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger index = indexPath.jnw_item;
  if (index >= _streams.count) {
    return;
  }

  NSDictionary *stream = [_streams objectAtIndex:indexPath.jnw_item];
  _tab.title = [[stream objectForKey:@"channel"] objectForKey:@"display_name"];
  [self loadChannelWithName:[[stream objectForKey:@"channel"] objectForKey:@"name"]];
}

- (void)loadChannelWithName:(NSString *)name {
  _name = [name copy];

  NSView *gridView = _gridView;
  _gridView = nil;
  [gridView removeFromSuperview];
  _streams = nil;

  _streamView = [[WebView alloc] init];
  _streamView.drawsBackground = NO;
  [_streamView setResourceLoadDelegate:self];
  [self addSubview:_streamView];
  [self loadStream];

  _chatView = [[WebView alloc] init];
  _chatView.drawsBackground = NO;
  [_chatView setPolicyDelegate:self];
  [self addSubview:_chatView];
  [self loadChat];

  [self delegateMaximization];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(WebFrame *)frame
decisionListener:(id<WebPolicyDecisionListener>)listener
{
  if (WebNavigationTypeLinkClicked == [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue])
  {
    [[NSWorkspace sharedWorkspace] openURL:request.URL];
  }
  [listener use];
}


-(void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
       request:(NSURLRequest *)request
  newFrameName:(NSString *)frameName
decisionListener:(id <WebPolicyDecisionListener>)listener
{
  if (WebNavigationTypeLinkClicked == [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue])
  {
    [[NSWorkspace sharedWorkspace] openURL:request.URL];
  }
  [listener ignore];
}


- (void)loadStream {
  NSURL *streamURL = [TVAPI streamURLWithName:_name];
  NSURLRequest *streamRequest = [[NSURLRequest alloc] initWithURL:streamURL];
  [[_streamView mainFrame] loadRequest:streamRequest];
}

- (void)loadChat {
  NSURL *chatURL = [TVAPI chatURLWithName:_name];
  NSURLRequest *chatRequest = [[NSURLRequest alloc] initWithURL:chatURL];
  [[_chatView mainFrame] loadRequest:chatRequest];
}

- (NSURLRequest *)webView:(WebView *)sender
                 resource:(id)identifier
          willSendRequest:(NSURLRequest *)request
         redirectResponse:(NSURLResponse *)redirectResponse
           fromDataSource:(WebDataSource *)dataSource {
  if ([request.URL.absoluteString rangeOfString:@"jtvnw.net/assets/pages/hls"].location == NSNotFound) {
    return request;
  }

  [[TVAdBlocker shared] setOriginalJTVURL:request.URL];

  NSMutableURLRequest *newRequest = [request mutableCopy];
  newRequest.URL = [NSURL URLWithString:@"http://www.twitch.proxy/adblock"];
  return newRequest;
}

- (void)maximizeStream {
  _maximizedStream = YES;
  [self delegateMaximization];
}

- (void)minimizeStream {
  _maximizedStream = NO;
  [self delegateMaximization];
}

- (void)delegateMaximization {
  [self viewResized];
  [_chatView setHidden:_maximizedStream];
}

- (void)footerView:(TVStreamFooterView *)footerView requestedChannelWithName:(NSString *)name {
  _tab.title = name;
  [self loadChannelWithName:name];
}

@end
