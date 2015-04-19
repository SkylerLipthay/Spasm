//
//  NSMenuItem+Grubber.m
//  Grubber
//
//  Created by Skyler Lipthay on 3/19/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <objc/runtime.h>

#import "NSMenuItem+Grubber.h"

static char * const kBlockActionKey = "BlockActionKey";

@implementation NSMenuItem (Grubber)

- (void)setBlockAction:(void (^)(id))block {
  objc_setAssociatedObject(self, kBlockActionKey, nil, OBJC_ASSOCIATION_RETAIN);

  if (block == nil) {
    [self setTarget:nil];
    [self setAction:NULL];

    return;
  }

  objc_setAssociatedObject(self, kBlockActionKey, block, OBJC_ASSOCIATION_RETAIN);
  [self setTarget:self];
  [self setAction:@selector(blockActionWrapper:)];
}

- (void (^)(id))blockAction {
  return objc_getAssociatedObject(self, kBlockActionKey);
}

- (void)blockActionWrapper:(id)sender {
  void (^block)(id) = objc_getAssociatedObject(self, kBlockActionKey);

  block(sender);
}

@end
