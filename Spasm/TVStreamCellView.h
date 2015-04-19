#import "JNWCollectionViewCell.h"

@interface TVStreamCellView : JNWCollectionViewCell {
 @private
  NSString *_viewerCount;
  NSString *_name;
}

@property NSImage *image;

- (void)setStream:(NSDictionary *)stream;

@end
