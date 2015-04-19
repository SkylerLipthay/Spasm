#import "TVView.h"
#import "TVViewerView.h"

#import "TVWindow.h"

const NSRect kTVWindowDefaultRect = { 0, 0, 1060, 580 };
const NSSize kTVWindowMinimumSize = { 800, 480 };
const NSUInteger kTVWindowStyleMask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
  | NSResizableWindowMask;

@implementation TVWindow

- (id)init {
  self = [super initWithContentRect:kTVWindowDefaultRect
                          styleMask:kTVWindowStyleMask
                            backing:NSBackingStoreBuffered
                              defer:YES];
  if (self == nil) {
    return nil;
  }

  [self setTitle:@"Spasm"];
  [self setContentView:[self buildView:@"TVAuthorizationView"]];
  [self setContentMinSize:kTVWindowMinimumSize];
  [self center];
  [self updateConstraintsIfNeeded];
  [self setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
  [self setAcceptsMouseMovedEvents:YES];

  [NSWindow registerWindowClassForCustomThemeFrameDrawing:[TVWindow class]];

  return self;
}

- (void)closeActiveTab:(id)sender {
  if ([self.contentView respondsToSelector:@selector(closeActiveTab:)]) {
    [self.contentView performSelector:@selector(closeActiveTab:) withObject:sender];
  }
}

- (void)newTab:(id)sender {
  if ([self.contentView respondsToSelector:@selector(newTab:)]) {
    [self.contentView performSelector:@selector(newTab:) withObject:sender];
  }
}

- (void)nextTab:(id)sender {
  if ([self.contentView respondsToSelector:@selector(nextTab:)]) {
    [self.contentView performSelector:@selector(nextTab:) withObject:sender];
  }
}

- (void)previousTab:(id)sender {
  if ([self.contentView respondsToSelector:@selector(previousTab:)]) {
    [self.contentView performSelector:@selector(previousTab:) withObject:sender];
  }
}

- (NSView *)buildView:(NSString *)viewType {
  TVView *view = [[NSClassFromString(viewType) alloc] init];
  view.stateController = self;

  return view;
}

- (void)authorizedWithCode:(NSString *)code {
  if (code == nil) {
    return;
  }

  TVViewerView *view = (TVViewerView *)[self buildView:@"TVViewerView"];
  view.code = code;
  [self setContentView:view];
}

- (BOOL)drawsAboveDefaultThemeFrame {
  return YES;
}

- (void)drawThemeFrame:(NSRect)dirtyRect {
  float maxY = NSMaxY(dirtyRect);

  BOOL isInFullScreen = [self styleMask] & NSFullScreenWindowMask;

  if (maxY > NSMaxY([self frame]) - 21 && !isInFullScreen) {
    float newHeight = [self frame].origin.y + [self frame].size.height - dirtyRect.origin.y - 21;
    dirtyRect.size.height = newHeight;
  }

  if (dirtyRect.size.height > 0) {
    [[NSColor colorWithWhite:0.2 alpha:1] set];
    NSRectFill(dirtyRect);
  }
}

- (void)logout:(id)sender {
  if (![self.contentView isKindOfClass:TVViewerView.class]) {
    return;
  }

  NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSURL *URL = [NSURL URLWithString:@"http://twitch.tv"];
  for (NSHTTPCookie *cookie in [cookieJar cookiesForURL:URL]) {
    [cookieJar deleteCookie:cookie];
  }

  [self setContentView:[self buildView:@"TVAuthorizationView"]];
}

- (void)maximizeStream:(id)sender {
  if ([self.contentView respondsToSelector:@selector(maximizeStream:)]) {
    [self.contentView performSelector:@selector(maximizeStream:) withObject:sender];
  }
}

@end
