//
//  AddUserViewController.h
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *sexTextFiled;
@property (nonatomic, copy) NSString *editUserId;
@end
