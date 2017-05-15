//
//  SQLiteModel.h
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteModel : NSObject

//userId
@property (nonatomic, copy) NSString *userId;
//用户名
@property (nonatomic, copy) NSString *username;
//年龄
@property (nonatomic, assign) int age;
//性别
@property (nonatomic, copy) NSString *sex;





@end
