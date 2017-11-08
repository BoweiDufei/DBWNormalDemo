//
//  NSObject+EX.m
//  UnifiedManagement
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 cn.com.lianda. All rights reserved.
//

#import "NSObject+EX.h"

@implementation NSObject(EX)
+ (id)ex_builder:(void(^)(id))block {
    id instance = [[self alloc] init];
    block(instance);
    return instance;
}

- (id)ex_builder:(void(^)(id))block {
    block(self);
    return self;
}

@end
