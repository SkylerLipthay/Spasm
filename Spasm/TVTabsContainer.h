#import <Cocoa/Cocoa.h>

#import "TVTab.h"

@class TVTabsContainer;

@protocol TVTabsContainerDelegate

- (void)tabsContainerDidEmpty:(TVTabsContainer *)tabsContainer;
- (void)tabsContainerWantsNewTab:(TVTabsContainer *)tabsContainer;

@end

@interface TVTabsContainer : NSView <TVTabDelegate> {
 @private
  NSMutableArray *_tabs;
  NSPoint _dragStart;
  NSPoint _tabStart;
  NSButton *_newButton;
}

@property (weak) id<TVTabsContainerDelegate> delegate;

- (void)addTab:(TVTab *)tab;
- (void)closeActiveTab;
- (void)nextTab;
- (void)previousTab;
- (NSUInteger)count;

@end
