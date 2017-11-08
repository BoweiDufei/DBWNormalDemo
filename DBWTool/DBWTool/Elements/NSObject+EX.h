//
//  NSObject+EX.h
//  UnifiedManagement
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 cn.com.lianda. All rights reserved.
//

#import <Foundation/Foundation.h>
#define init(type,args)             \
@property (nonatomic,strong) type *args;


#define get(type,args)                  \
-(type *)args{               \
if (!_##args) {                          \
_##args = [type new];      \
}                                           \
return _##args;                          \
}

#define SingletonH(name) + (instancetype)shared##name;

#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}
@interface NSObject(EX)
+ (id)ex_builder:(void(^)(id that))block;
- (id)ex_builder:(void(^)(id that))block;
@end
