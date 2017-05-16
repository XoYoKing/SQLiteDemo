//
//  HomeTableViewCell.m
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "AddUserViewController.h"

@implementation HomeTableViewCell
{
    CGPoint beginPoint;
    RefreshBlock _refreshBlock;
    UIPanGestureRecognizer *_pan;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _userIdLabel.adjustsFontSizeToFitWidth = YES;
    _sexLabel.adjustsFontSizeToFitWidth = YES;
    
    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-70, 0, 70, 60)];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = [UIColor redColor];
    [_deleteBtn addTarget:self action:@selector(deleteBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:_deleteBtn belowSubview:self.contentView];
    
    _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-140, 0, 70, 60)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.backgroundColor = [UIColor grayColor];
    [_editBtn addTarget:self action:@selector(editBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:_editBtn belowSubview:self.contentView];
    
  
    //.平移手势
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAct:)];
    _pan.delegate = self;

    _pan.delaysTouchesBegan = YES;

    //添加平移手势
    [self.contentView addGestureRecognizer:_pan];
    _isSlided = NO;
}


//平移方法
- (void)panAct:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:pan.view];

    CGFloat value = point.x;
    if (self.contentView.left < -(70 + 70) * 1.1 || self.contentView.left > 30) {
        value = 0;
    }
    self.contentView.left += value;

    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat x = 0;
        if (self.contentView.left < -30 && !self.isSlided) {
            x = -140;
            self.isSlided = YES;
        }else{
            self.isSlided = NO;
        }
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.contentView.left = x;
        } completion:^(BOOL finished) {
        }];
        
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}



- (void)setModel:(SQLiteModel *)model{
    _model = model;
    
    _usernameLabel.text = _model.username;
    _ageLabel.text = [NSString stringWithFormat:@"%d岁",_model.age];
    _sexLabel.text = _model.sex;
    _userIdLabel.text = [NSString stringWithFormat:@"userId:%@",_model.userId];
}

- (void)deleteBtnAct:(UIButton *)deleteBtn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除这条数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL deleteSuccess = [[SQLiteManger sharedSQLiteManger]deleteDataWithUserId:_model.userId];
        if (deleteSuccess) {
            [iToast showiToast:[self returnVC].view :@"删除成功"];
            _refreshBlock();
        }
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancleAction];
    [[self returnVC] presentViewController:alertController animated:YES completion:nil];
    
}

- (void)editBtnAct:(UIButton *)editBtn{
    AddUserViewController *editVc = [AddUserViewController new];
    editVc.editUserId = _model.userId;
    [[self returnVC].navigationController pushViewController:editVc animated:YES];
}
- (void)methodForRefresh:(RefreshBlock)refreshBlock{
    _refreshBlock = refreshBlock;
}


#pragma mark - gestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.contentView.left <= -2 && otherGestureRecognizer != _pan) {
        return NO;
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
