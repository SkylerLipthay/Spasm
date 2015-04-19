//
//  Grubber.h
//  Grubber
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NSMenu+Grubber.h"

@interface Grubber : NSMenu

- (NSMenu *(^)(NSString *, void(^)(Grubber *)))submenu;
- (NSMenuItem *(^)(NSString *, SEL, NSString *))item;
- (NSMenuItem *(^)(NSString *, void(^)(id), NSString *))itemBlock;
- (NSMenuItem *(^)())separator;

@end
