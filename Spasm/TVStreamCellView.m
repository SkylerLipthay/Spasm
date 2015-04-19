#import "TVImageManager.h"

#import "TVStreamCellView.h"

const NSRect kTVStreamCellViewBodyFrame = { 10, 20, 240, 160 };
const NSRect kTVStreamCellViewImageFrame = { 10, 40, 240, 140 };

@implementation TVStreamCellView

- (void)setStream:(NSDictionary *)stream {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  _viewerCount = [formatter stringFromNumber:[stream objectForKey:@"viewers"]];
  _name = [[[stream objectForKey:@"channel"] objectForKey:@"display_name"] copy];
  [[TVImageManager shared] loadImageForCellView:self withURL:[stream objectForKey:@"preview"]];
}

- (void)dealloc {
  [[TVImageManager shared] clearRequestsForTarget:self];
}

- (void)resetCursorRects {
  [self addCursorRect:kTVStreamCellViewBodyFrame cursor:[NSCursor pointingHandCursor]];
}

- (void)drawRect:(NSRect)dirtyRect {
  if (_image == nil) {
    [[NSColor grayColor] set];
    [NSBezierPath fillRect:kTVStreamCellViewImageFrame];
  } else {
    [_image drawInRect:kTVStreamCellViewImageFrame
              fromRect:NSZeroRect
             operation:NSCompositeSourceOver
              fraction:1];
  }

  NSShadow *shadow = [NSShadow new];
  [shadow setShadowColor:[NSColor colorWithWhite:0 alpha:0.5]];
  [shadow setShadowOffset:CGSizeMake(0, -1)];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];

  NSDictionary *nameAttrs = @{ NSFontAttributeName: [NSFont boldSystemFontOfSize:12],
                               NSForegroundColorAttributeName: [NSColor whiteColor],
                               NSShadowAttributeName: shadow,
                               NSParagraphStyleAttributeName: paragraphStyle };

  NSMutableParagraphStyle *rightParagraphStyle = [paragraphStyle mutableCopy];
  [rightParagraphStyle setAlignment:NSRightTextAlignment];
  NSDictionary *viewersAttrs = @{ NSFontAttributeName: [NSFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName: [NSColor whiteColor],
                                  NSShadowAttributeName: shadow,
                                  NSParagraphStyleAttributeName: rightParagraphStyle };

  NSRect viewersStringRect;
  viewersStringRect.size = NSMakeSize([_viewerCount sizeWithAttributes:viewersAttrs].width, 18);
  viewersStringRect.size.width = MIN(viewersStringRect.size.width, 55);
  viewersStringRect.origin = NSMakePoint(250 - viewersStringRect.size.width, 19);
  [_viewerCount drawInRect:viewersStringRect withAttributes:viewersAttrs];

  [[NSImage imageNamed:@"user"] drawInRect:NSMakeRect(viewersStringRect.origin.x - 16, 23, 12, 12)
                                  fromRect:NSZeroRect
                                 operation:NSCompositeSourceOver
                                  fraction:1.0];

  [_name drawInRect:NSMakeRect(10, 19, 160, 18) withAttributes:nameAttrs];

  [super drawRect:dirtyRect];
}

@end
