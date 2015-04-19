#import <Foundation/Foundation.h>

@interface TVAPI : NSObject

+ (NSURL *)authorizationURL;
+ (NSURL *)streamListURLWithOffset:(NSUInteger)offset;
+ (NSURL *)streamURLWithName:(NSString *)name;
+ (NSURL *)chatURLWithName:(NSString *)name;

+ (NSDictionary *)URLQueryParameters:(NSURL *)URL;

@end
