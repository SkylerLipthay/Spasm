//
//  Keyposit.m
//  Keyposit
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Keyposit.h"

@interface Keyposit ()

- (void)parseDescriptor:(NSString *)descriptor;

@end

@implementation Keyposit

- (id)initWithDescriptor:(NSString *)descriptor {
  if ((self = [super init]) == nil) {
    return nil;
  }

  [self parseDescriptor:descriptor];

  return self;
}

+ (id)keypositWithDescriptor:(NSString *)descriptor {
  return [[self alloc] initWithDescriptor:descriptor];
}

- (void)parseDescriptor:(NSString *)descriptor {
  NSArray * const parts = [descriptor componentsSeparatedByString:@"-"];
  NSMutableArray * const leftovers = [NSMutableArray array];

  for (NSString * const part in parts) {
    if ([part caseInsensitiveCompare:@"Shift"] == NSOrderedSame) {
      _modifierMask |= NSShiftKeyMask;
    } else if ([part caseInsensitiveCompare:@"Alt"] == NSOrderedSame) {
      _modifierMask |= NSAlternateKeyMask;
    } else if ([part caseInsensitiveCompare:@"Ctrl"] == NSOrderedSame) {
      _modifierMask |= NSControlKeyMask;
    } else if ([part caseInsensitiveCompare:@"Cmd"] == NSOrderedSame) {
      _modifierMask |= NSCommandKeyMask;
    } else {
      [leftovers addObject:part];
    }
  }

  if ([leftovers isEqualToArray:@[@"", @""]]) {
    _key = @"-";
  } else if ([leftovers count] > 0) {
    _key = [leftovers lastObject];
  } else {
    _key = @"";
  }
}

@end
