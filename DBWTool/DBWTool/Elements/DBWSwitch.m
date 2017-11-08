//
//  DBWSwitch.m
//  UnifiedManagement
//
//  Created by dbw on 2017/7/25.
//  Copyright © 2017年 cn.com.lianda. All rights reserved.
//

#import "DBWSwitch.h"
#import <objc/runtime.h>
NSString *keys = @"indexPath";

@implementation UISwitch(DBWSwitch)
-(void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &keys, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSIndexPath *)indexPath{
   NSIndexPath *index =  objc_getAssociatedObject(self, &keys);
    return index;
}
@end
