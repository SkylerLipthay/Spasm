//
//  Grubber.m
//  Grubber
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import "Keyposit.h"

#import "Grubber.h"
#import "NSMenuItem+Grubber.h"

@implementation Grubber

- (NSMenu *(^)(NSString *, void(^)(Grubber *)))submenu {
  return ^NSMenu *(NSString *title, void(^block)(Grubber *)) {
    NSMenuItem * const menuItem = [[NSMenuItem alloc] init];

    Grubber * const menu = [[Grubber alloc] initWithTitle:title];
    [menuItem setTitle:title];
    [menuItem setSubmenu:menu];
    [self addItem:menuItem];

    block(menu);

    return menu;
  };
}

- (NSMenuItem *(^)(NSString *, SEL, NSString *))item {
  return ^NSMenuItem *(NSString *title, SEL selector, NSString *keypositDescriptor) {
    NSMenuItem * const menuItem = [[NSMenuItem alloc] initWithTitle:title
                                                             action:selector
                                                      keyEquivalent:@""];
    Keyposit * const keyposit = [Keyposit keypositWithDescriptor:keypositDescriptor];
    [menuItem setKeyEquivalent:[keyposit key]];
    [menuItem setKeyEquivalentModifierMask:[keyposit modifierMask]];
    [self addItem:menuItem];

    return menuItem;
  };
}

- (NSMenuItem *(^)(NSString *, void(^)(id), NSString *))itemBlock {
  return ^NSMenuItem *(NSString *title, void(^block)(id), NSString *keypositDescriptor) {
    NSMenuItem * const menuItem = [[NSMenuItem alloc] initWithTitle:title
                                                             action:nil
                                                      keyEquivalent:@""];
    Keyposit * const keyposit = [Keyposit keypositWithDescriptor:keypositDescriptor];
    [menuItem setBlockAction:block];
    [menuItem setKeyEquivalent:[keyposit key]];
    [menuItem setKeyEquivalentModifierMask:[keyposit modifierMask]];
    [self addItem:menuItem];

    return menuItem;
  };
}

- (NSMenuItem *(^)())separator {
  return ^NSMenuItem *() {
    NSMenuItem * const menuItem = [NSMenuItem separatorItem];
    [self addItem:menuItem];

    return menuItem;
  };
}

@end
