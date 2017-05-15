//
//  UIView+ReturnVC.m
//  UI10-task-响应者链
//
//  Created by imac on 15/7/31.
//  Copyright (c) 2015年 wangjin. All rights reserved.
//

#import "UIView+ReturnVC.h"

@implementation UIView (ReturnVC)

//通过响应者链,取得此视图的视图控制器对象
- (UIViewController *)returnVC
{
    //创建一个UIResponder对象
    UIResponder *next = self.nextResponder;
    
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            UIViewController *rVC = (UIViewController *)next;
            return rVC;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end
