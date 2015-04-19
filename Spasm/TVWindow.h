#import <Cocoa/Cocoa.h>

#import "NSWindow+TVCustomWindow.h"

#import "TVStateController.h"

@interface TVWindow : NSWindow <TVStateController, OECustomWindow>

- (void)newTab:(id)sender;
- (void)closeActiveTab:(id)sender;
- (void)nextTab:(id)sender;
- (void)previousTab:(id)sender;
- (void)logout:(id)sender;
- (void)maximizeStream:(id)sender;

@end
