//
//  NSMenuItem+Grubber.h
//  Grubber
//
//  Created by Skyler Lipthay on 3/19/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenuItem (Grubber)

- (void)setBlockAction:(void (^)(id sender))block;
- (void (^)(id))blockAction;

@end
