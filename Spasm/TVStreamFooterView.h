#import "JNWCollectionViewReusableView.h"

@class TVStreamFooterView;

@protocol TVStreamFooterViewDelegate

- (void)footerView:(TVStreamFooterView *)footerView requestedChannelWithName:(NSString *)name;

@end

@interface TVStreamFooterView : JNWCollectionViewReusableView <NSTextFieldDelegate> {
 @private
  NSTextField *_input;
}

@property (weak) id<TVStreamFooterViewDelegate> delegate;

@end
