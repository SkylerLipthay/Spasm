#import <Cocoa/Cocoa.h>

#import "TVWindow.h"

@interface TVAppDelegate : NSObject <NSApplicationDelegate> {
 @private
  TVWindow *_window;
  NSMenuItem *_adBlockToggle;
}

@end
