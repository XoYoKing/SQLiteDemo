//
//  iToast.h
//  wiseCloudCrm
//
//  Created by qiyun002 on 14-11-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iToast : UIView
{
    UILabel *_textLabel;
    int _queueCount;
}

- (void) setText:(NSString *) text;

+ (void) showiToast:(UIView *)view :(NSString *)text;
+ (void) showiToast:(UIView *)view :(NSString *)text Y:(CGFloat)y;

@end
