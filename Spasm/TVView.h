#import <Cocoa/Cocoa.h>

#import "TVStateController.h"

@interface TVView : NSView {
 @private
  NSGradient *_gradient;
}

@property (weak) id<TVStateController> stateController;

- (void)viewResized;
- (BOOL)drawsBackground;

@end
