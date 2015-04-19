#import <Cocoa/Cocoa.h>

@class TVStreamCellView;

@interface TVImageManager : NSObject {
 @private
  NSMutableDictionary *_images;
  NSMutableDictionary *_cells;
}

+ (TVImageManager *)shared;
- (void)clear;
- (void)clearRequestsForTarget:(id)target;
- (void)loadImageForCellView:(TVStreamCellView *)cellView withURL:(NSString *)URL;

@end
