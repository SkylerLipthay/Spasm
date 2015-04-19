//
//  NSMenu+Grubber.h
//  Grubber
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Grubber;

@interface NSMenu (Grubber)

+ (NSMenu *)grub:(void(^)(Grubber *grub))block;

@end
