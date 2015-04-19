//
//  Keyposit.h
//  Keyposit
//
//  Created by Skyler Lipthay on 3/13/14.
//  Copyright (c) 2014 Skyler Lipthay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keyposit : NSObject

@property (readonly) NSUInteger modifierMask;
@property (readonly) NSString *key;

- (id)initWithDescriptor:(NSString *)descriptor;
+ (id)keypositWithDescriptor:(NSString *)descriptor;

@end
