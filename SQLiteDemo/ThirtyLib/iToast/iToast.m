//
//  iToast.m
//  wiseCloudCrm
//
//  Created by qiyun002 on 14-11-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "iToast.h"
//#import <QuartzCore/QuartzCore.h>

@implementation iToast

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.75f];
        self.layer.cornerRadius = 5.0f;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
//        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        _queueCount = 0;
    }
    return self;
}

- (void) setText:(NSString *) text
{
    _textLabel.frame = CGRectMake(0, 0, 100, 10);
    _queueCount ++;
    self.alpha = 1.0f;

    if (text.length > 21) {

        [_textLabel setNumberOfLines:2];

        _textLabel.text = text;

        _textLabel.textAlignment = NSTextAlignmentCenter;

        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;

        CGRect frame = CGRectMake(5, 0, kDeviceWidth - 40, 50);

        _textLabel.frame = frame;

        frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y,  kDeviceWidth - 30, 50);

        self.frame = frame;

    }else{
        [_textLabel setNumberOfLines:1];
        _textLabel.text = text;
        [_textLabel sizeToFit];
        CGRect frame = CGRectMake(12, 10, _textLabel.frame.size.width, _textLabel.frame.size.height);
        _textLabel.frame = frame;
        frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y, _textLabel.frame.size.width+24, _textLabel.frame.size.height+20);
        self.frame = frame;
    }

    self.center = CGPointMake(kDeviceWidth/2, kDeviceHeight-60);
    
    [UIView animateWithDuration:0.3
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if (_queueCount == 1) {
                             [self removeFromSuperview];
                         }
                         _queueCount--;
                         
                     }
     ];
}

+ (void)showiToast:(UIView *)view :(NSString *)text{
    iToast *toast = [[iToast alloc]init];
    [view addSubview:toast];
    [toast setText:text];
}

+ (void)showiToast:(UIView *)view :(NSString *)text Y:(CGFloat)y{
    iToast *toast = [[iToast alloc]init];
    [view addSubview:toast];
    [toast setText:text];
    toast.center = CGPointMake(kDeviceWidth/2, y);
}

@end
