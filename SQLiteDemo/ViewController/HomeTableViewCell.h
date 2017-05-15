//
//  HomeTableViewCell.h
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteModel.h"

typedef void(^RefreshBlock)();

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, strong) SQLiteModel *model;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (nonatomic, assign) BOOL isSlided;


@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *editBtn;



- (void)methodForRefresh:(RefreshBlock)refreshBlock;
@end
