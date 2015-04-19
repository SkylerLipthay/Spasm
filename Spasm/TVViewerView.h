#import "TVView.h"
#import "TVTabsContainer.h"

@interface TVViewerView : TVView <TVTabsContainerDelegate> {
 @private
  TVTabsContainer *_tabsContainer;
  NSTimer *_refreshTimer;
  NSArray *_streams;
  BOOL _maximizedStream;
}

@property (setter = setCode:, nonatomic) NSString *code;

- (void)closeActiveTab:(id)sender;
- (void)newTab:(id)sender;
- (void)nextTab:(id)sender;
- (void)previousTab:(id)sender;
- (void)maximizeStream:(id)sender;

@end
