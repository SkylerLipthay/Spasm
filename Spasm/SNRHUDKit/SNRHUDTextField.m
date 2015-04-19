#import "SNRHUDTextFieldCell.h"

#import "SNRHUDTextField.h"

@implementation SNRHUDTextField

- (id)initWithFrame:(NSRect)frameRect {
  if ((self = [super initWithFrame:frameRect])) {
    [self setDrawsBackground:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
  }
  return self;
}

+ (void)load {
  [self setCellClass:SNRHUDTextFieldCell.class];
}

@end
