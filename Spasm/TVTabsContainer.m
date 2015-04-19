#import "TVTabContents.h"

#import "TVTabsContainer.h"

const CGFloat kTVTabsContainerMaxTabWidth = 180;
const CGFloat kTVTabsContainerNewTabButtonSpace = 22;

@implementation TVTabsContainer

- (id)init {
  if ((self = [super initWithFrame:NSMakeRect(0, 0, 0, 24)]) == nil) {
    return nil;
  }

  _tabs = [[NSMutableArray alloc] init];

  _newButton = [[NSButton alloc] init];
  [_newButton setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
  [_newButton setBordered:NO];
  [[_newButton cell] setImageScaling:NSImageScaleProportionallyDown];
  _newButton.target = self;
  _newButton.action = @selector(newPressed);
  [self addSubview:_newButton];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(layoutTabs)
                                               name:NSViewFrameDidChangeNotification
                                             object:self];

  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)count {
  return _tabs.count;
}

static NSComparisonResult TVTabsContainerSortTabsFunction(NSView *a, NSView *b, void *context) {
  if (a == (__bridge NSView *)context) {
    return NSOrderedDescending;
  } else if (b == (__bridge NSView *)context) {
    return NSOrderedAscending;
  }

  return NSOrderedSame;
}

- (void)tabMouseDown:(TVTab *)tab event:(NSEvent *)event {
  _dragStart = [self convertPoint:[event locationInWindow] fromView:nil];
  _tabStart = tab.frame.origin;

  [self sortSubviewsUsingFunction:TVTabsContainerSortTabsFunction context:(__bridge void *)tab];
}

- (void)tabMouseUp:(TVTab *)tab event:(NSEvent *)event {
  [self layoutTabs];

  for (TVTab *otherTab in _tabs) {
    if (otherTab == tab) {
      continue;
    }

    otherTab.active = NO;
    [otherTab.view setHidden:YES];
    [otherTab setNeedsDisplay:YES];
  }

  tab.active = YES;
  [tab.view setHidden:NO];
  [tab setNeedsDisplay:YES];
}

- (void)tabDragged:(TVTab *)tab event:(NSEvent *)event {
  NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
  NSRect frame = tab.frame;
  frame.origin.x = point.x - (_dragStart.x - _tabStart.x);
  tab.frame = frame;

  [self orderTabsByLocation];
  [self layoutTabsIgnoringTab:tab];
}

- (void)orderTabsByLocation {
  [_tabs sortUsingComparator:^NSComparisonResult(TVTab *a, TVTab *b) {
    CGFloat ax = a.frame.origin.x + (a.frame.size.width / 2);
    CGFloat bx = b.frame.origin.x + (b.frame.size.width / 2);
    if (ax > bx) {
      return NSOrderedDescending;
    } else if (ax < bx) {
      return NSOrderedAscending;
    }

    return NSOrderedSame;
  }];
}

- (void)addTab:(TVTab *)tab {
  for (TVTab *otherTab in _tabs) {
    otherTab.active = NO;
    [otherTab.view setHidden:YES];
    [otherTab setNeedsDisplay:YES];
  }

  tab.delegate = self;
  tab.active = YES;
  [tab.closeButton setTarget:self];
  [tab.closeButton setAction:@selector(closePressed:)];
  [tab.view setHidden:NO];
  [_tabs addObject:tab];
  [self addSubview:tab];

  [self layoutTabs];
}

- (void)nextTab {
  for (NSInteger index = 0; index < _tabs.count; index++) {
    if (![[_tabs objectAtIndex:index] active]) {
      continue;
    }

    [self selectTabAtIndex:index + 1 >= _tabs.count ? 0 : index + 1];

    break;
  }
}

- (void)previousTab {
  for (NSInteger index = 0; index < _tabs.count; index++) {
    if (![[_tabs objectAtIndex:index] active]) {
      continue;
    }

    [self selectTabAtIndex:index - 1 < 0 ? _tabs.count - 1 : index - 1];

    break;
  }
}

- (void)selectTabAtIndex:(NSUInteger)newIndex {
  if (newIndex >= _tabs.count) {
    return;
  }

  for (NSInteger index = 0; index < _tabs.count; index++) {
    TVTab *tab = [_tabs objectAtIndex:index];
    tab.active = newIndex == index;
    [tab.view setHidden:!tab.active];
    [tab setNeedsDisplay:YES];
  }
}

- (void)newPressed {
  [_delegate tabsContainerWantsNewTab:self];
}

- (void)layoutTabs {
  [self layoutTabsIgnoringTab:nil];
}

- (void)layoutTabsIgnoringTab:(TVTab *)ignoreTab {
  CGFloat room = self.bounds.size.width - kTVTabsContainerNewTabButtonSpace;
  CGFloat tabWidth = MIN(room / _tabs.count, kTVTabsContainerMaxTabWidth);

  _newButton.frame = NSMakeRect(tabWidth * _tabs.count, 0, 22, 22);

  if (_tabs.count == 0) {
    return;
  }

  CGFloat x = 0;

  for (TVTab *tab in _tabs) {
    if (tab != ignoreTab) {
      tab.frame = NSMakeRect(x, 0, tabWidth, 22);
    }

    x += tabWidth;
  }
}

- (void)closeActiveTab {
  TVTab *removalTab;

  for (TVTab *tab in _tabs) {
    if (tab.active) {
      removalTab = tab;
      break;
    }
  }

  if (removalTab == nil) {
    return;
  }

  NSInteger index = [_tabs indexOfObject:removalTab];
  [removalTab.view teardown];
  [removalTab.view removeFromSuperview];
  [removalTab setView:nil];
  [removalTab removeFromSuperview];
  [_tabs removeObjectAtIndex:index];

  index = index >= _tabs.count ? _tabs.count - 1 : index;
  if (_tabs.count > index) {
    TVTab *tab = [_tabs objectAtIndex:index];
    tab.active = YES;
    [tab.view setHidden:NO];
    [tab setNeedsDisplay:YES];
  }

  [self layoutTabs];

  if (_tabs.count == 0) {
    [_delegate tabsContainerDidEmpty:self];
  }
}

- (void)closePressed:(id)sender {
  NSButton *button = sender;
  TVTab *tab = (TVTab *)button.superview;

  if (tab.active) {
    [self closeActiveTab];
    return;
  }

  [tab.view removeFromSuperview];
  [tab.view teardown];
  [tab setView:nil];
  [tab removeFromSuperview];
  [_tabs removeObject:tab];

  [self layoutTabs];

  if (_tabs.count == 0) {
    [_delegate tabsContainerDidEmpty:self];
  }
}

- (void)drawRect:(NSRect)dirtyRect {
  NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithWhite:0.1 alpha:1]
                                                       endingColor:[NSColor colorWithWhite:0.2 alpha:1]];
  [gradient drawInRect:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height - 2) angle:90];

  [[NSColor blackColor] set];
  NSRectFill(NSMakeRect(0, self.bounds.size.height - 2, self.bounds.size.width, 1));
  [[NSColor colorWithWhite:0.4 alpha:1] set];
  NSRectFill(NSMakeRect(0, self.bounds.size.height - 1, self.bounds.size.width, 1));

  [super drawRect:dirtyRect];
}

- (BOOL)isFlipped {
  return YES;
}

@end
