#import "SNRHUDButtonCell.h"

#import "SNRHUDButton.h"

@implementation SNRHUDButton

- (id)initWithFrame:(NSRect)frameRect {
  if ((self = [super initWithFrame:frameRect])) {
    [self setBezelStyle:NSRegularSquareBezelStyle];
    [self setFocusRingType:NSFocusRingTypeNone];
  }
  return self;
}

+ (void)load {
  [self setCellClass:SNRHUDButtonCell.class];
}

@end
