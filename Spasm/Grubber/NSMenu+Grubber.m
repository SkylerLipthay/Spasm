//
//  NSMenu+Grubber.m
//  Grubber
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <objc/runtime.h>

#import "Grubber.h"
#import "NSMenu+Grubber.h"
#import "NSMenuItem+Grubber.h"

@implementation NSMenu (Grubber)

+ (NSMenu *)grub:(void(^)(Grubber *grub))block {
  Grubber *grub = [[Grubber alloc] init];
  block(grub);

  return grub;
}

@end
