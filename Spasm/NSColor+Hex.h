#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)

- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;

@end
