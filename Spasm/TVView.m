#import "TVView.h"

@implementation TVView

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(viewResized)
                                               name:NSViewFrameDidChangeNotification
                                             object:self];

  NSColor *glareColor = [NSColor colorWithWhite:1 alpha:0.15];
  _gradient = [[NSGradient alloc] initWithStartingColor:glareColor
                                            endingColor:[NSColor clearColor]];

  return self;
}

- (BOOL)becomeFirstResponder {
  return YES;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewResized {
}

- (BOOL)isFlipped {
  return YES;
}

- (BOOL)drawsBackground {
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  if (![self drawsBackground]) {
    return;
  }

  [[NSColor colorWithPatternImage:[NSImage imageNamed:@"noise"]] set];
  NSRectFill(self.bounds);

  [_gradient drawInRect:self.bounds relativeCenterPosition:NSMakePoint(0, -1)];

  [super drawRect:dirtyRect];
}

@end
