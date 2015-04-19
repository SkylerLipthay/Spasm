#import <Foundation/Foundation.h>

@interface TVAdBlocker : NSObject {
 @private
  NSURL *_originalJTVURL;
  NSString *_originalJTVCode;
  NSString *_newJTVCode;
}

+ (TVAdBlocker *)shared;
+ (BOOL)shouldBlockAds;
+ (void)setShouldBlockAds:(BOOL)shouldBlockAds;

- (void)setOriginalJTVURL:(NSURL *)originalJTVURL;

@end
