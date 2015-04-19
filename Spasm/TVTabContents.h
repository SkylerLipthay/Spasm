#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "JNWCollectionView.h"
#import "TVStreamFooterView.h"

@class TVTab;

@interface TVTabContents : NSView <JNWCollectionViewDataSource, JNWCollectionViewGridLayoutDelegate, JNWCollectionViewDelegate, TVStreamFooterViewDelegate> {
 @private
  JNWCollectionView *_gridView;
  WebView *_streamView;
  WebView *_chatView;
  NSString *_name;
  BOOL _maximizedStream;
}

@property (setter = setStreams:, nonatomic) NSArray *streams;
@property (weak) TVTab *tab;

- (void)maximizeStream;
- (void)minimizeStream;
- (void)teardown;

@end
