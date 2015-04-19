#import "NSColor+Hex.h"

#import "TVTab.h"
#import "TVTabContents.h"

@implementation TVTab

- (id)initWithFrame:(NSRect)frame {
  if ((self = [super initWithFrame:NSMakeRect(0, 0, 0, 22)]) == nil) {
    return nil;
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(viewResized)
                                               name:NSViewFrameDidChangeNotification
                                             object:self];

  _closeButton = [[NSButton alloc] init];
  [_closeButton setImage:[NSImage imageNamed:NSImageNameStopProgressFreestandingTemplate]];
  [_closeButton setBezelStyle:NSInlineBezelStyle];
  [[_closeButton cell] setImageScaling:NSImageScaleProportionallyDown];
  [self addSubview:_closeButton];

  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewResized {
  const NSTrackingAreaOptions flags = NSTrackingMouseMoved | NSTrackingActiveInKeyWindow |
  NSTrackingMouseEnteredAndExited;

  [self removeTrackingArea:_trackingArea];
  _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:flags owner:self userInfo:nil];
  [self addTrackingArea:_trackingArea];

  _closeButton.frame = NSMakeRect(self.bounds.size.width - 18, 5, 12, 12);
}

- (void)drawRect:(NSRect)dirtyRect {
  NSColor *light;
  NSColor *dark;

  if (_active) {
    light = [NSColor colorFromHexadecimalValue:@"9473ce"];
    dark = [NSColor colorFromHexadecimalValue:@"653ea8"];
  } else {
    light = [NSColor colorWithWhite:0.5 alpha:1];
    dark = [NSColor colorWithWhite:0.35 alpha:1];
  }

  NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:dark endingColor:light];
  [gradient drawInRect:self.bounds angle:90];

  if (self.frame.origin.x > 0) {
    [[NSColor colorWithWhite:1 alpha:0.3] set];
    [NSBezierPath fillRect:NSMakeRect(0, 0, 1, self.bounds.size.height)];
  }
  if (self.frame.origin.x + self.frame.size.width < self.superview.bounds.size.width) {
    [[NSColor colorWithWhite:0 alpha:0.3] set];
    [NSBezierPath fillRect:NSMakeRect(self.bounds.size.width - 1, 0, 1, self.bounds.size.height)];
  }

  if (_hover) {
    gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithWhite:1 alpha:0.09]
                                             endingColor:[NSColor clearColor]];
    [gradient drawFromCenter:_hoverPoint radius:0 toCenter:_hoverPoint radius:200
                     options:NSGradientDrawsBeforeStartingLocation];
  }

  if (_title == nil) {
    [super drawRect:dirtyRect];
    return;
  }

  NSFont *font = [NSFont systemFontOfSize:12];
  NSColor *color;
  NSShadow *shadow = [NSShadow new];

  if (_active) {
    [shadow setShadowColor:[NSColor colorWithWhite:0 alpha:0.5]];
    [shadow setShadowOffset:CGSizeMake(0, -1)];
    color = [NSColor whiteColor];
  } else {
    [shadow setShadowColor:[NSColor colorWithWhite:0 alpha:0.5]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    color = [NSColor colorWithWhite:0.75 alpha:1];
  }

  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];

  NSDictionary *attrs = @{NSFontAttributeName: font,
                          NSForegroundColorAttributeName: color,
                          NSShadowAttributeName: shadow,
                          NSParagraphStyleAttributeName: paragraphStyle};
  NSRect stringRect = NSMakeRect(6, 2, self.bounds.size.width - 24, 18);
  [_title drawInRect:stringRect withAttributes:attrs];

  [super drawRect:dirtyRect];
}

- (void)mouseMoved:(NSEvent *)event {
  _hover = YES;
  _hoverPoint = [self convertPoint:[event locationInWindow] fromView:nil];
  _hoverPoint.y = 2;
  [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event {
  [_delegate tabDragged:self event:event];
}

- (void)mouseExited:(NSEvent *)event {
  _hover = NO;
  [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
  [_delegate tabMouseDown:self event:event];
}

- (void)mouseUp:(NSEvent *)event {
  [_delegate tabMouseUp:self event:event];
}

- (void)setView:(TVTabContents *)view {
  _view.tab = nil;
  _view = view;
  _view.tab = self;
}

- (void)setTitle:(NSString *)title {
  _title = [title copy];
  [self setNeedsDisplay:YES];
}

@end
