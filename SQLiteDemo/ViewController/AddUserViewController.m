//
//  AddUserViewController.m
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmBtnAct:(UIButton *)sender {
    if (_userNameTextField.text.length == 0) {
        [iToast showiToast:self.view :@"用户名不能为空"];
        return;
    }else if (_ageTextFiled.text.length == 0){
        [iToast showiToast:self.view :@"年龄不能为空"];
        return;
    }else if (_sexTextFiled.text.length == 0){
        [iToast showiToast:self.view :@"性别不能为空"];
        return;
    }
    
    
    if (!_editUserId) {
        NSString *newUserId;
        NSString *maxUserId = [[SQLiteManger sharedSQLiteManger]queryMaxUserId];
        if ([maxUserId isEqualToString:@"NONE"]) {
            newUserId = @"U-00000001";
        }else if ([maxUserId isEqualToString:@"error"]){
            
        }else{
            newUserId = [self userIdForTheNextOfTheUserId:maxUserId];
        }
        BOOL success = NO;
        if (newUserId) {
            success = [[SQLiteManger sharedSQLiteManger]insertDataWithUserId:newUserId username:_userNameTextField.text age:_ageTextFiled.text.intValue sex:_sexTextFiled.text];
        }
        
        if (success) {
            [iToast showiToast:self.view :@"创建成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [iToast showiToast:self.view :@"创建失败,请重试"];
        }

    }else{
        BOOL editSuccess = [[SQLiteManger sharedSQLiteManger]updateDataWithUserId:_editUserId newName:_userNameTextField.text newAge:_ageTextFiled.text.intValue newSex:_sexTextFiled.text];
        
        if (editSuccess) {
            [iToast showiToast:self.view :@"编辑成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [iToast showiToast:self.view :@"编辑失败,请重试"];
        }
    }
    
    
    
    
}


/**
 根据查出来的id拼接新建的id

 @param userId 查出来的最大id
 @return 新建的user的id
 */
- (NSString *)userIdForTheNextOfTheUserId:(NSString *)userId{
    NSInteger reallyId = [[userId substringFromIndex:2]integerValue];
    reallyId ++;
    
    NSString *tempStr = [NSString stringWithFormat:@"%ld",reallyId];
    NSInteger length = tempStr.length;
    for (int j = 0; j < 8-length; j++) {
        tempStr = [NSString stringWithFormat:@"0%@",tempStr];
    }
    
    return [NSString stringWithFormat:@"U-%@",tempStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
