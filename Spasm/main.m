#import <Cocoa/Cocoa.h>

#import "TVAppDelegate.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    NSApplication *application = [NSApplication sharedApplication];
    TVAppDelegate *applicationDelegate = [[TVAppDelegate alloc] init];
    [application setDelegate:applicationDelegate];
    [application run];
  }

  return 0;
}
