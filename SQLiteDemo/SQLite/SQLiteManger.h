//
//  SQLiteManger.h
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteManger : NSObject


/**
 获取SQLiteManger单例

 @return 单例对象
 */
+ (instancetype)sharedSQLiteManger;
/**
 创建表

 @return 返回是否创建成功
 */
- (BOOL)createTable;

/**
 插入数据

 @param userId userId
 @param username 用户名
 @param age 年龄
 @param sex 性别
 @return 是否插入成功
 */
- (BOOL)insertDataWithUserId:(NSString *)userId username:(NSString *)username age:(int)age sex:(NSString *)sex;

/**
 查询所有数据

 @return 返回查询的结果
 */
- (NSArray *)queryData;

/**
 更新数据

 @param userId userId
 @param newName 新名字
 @param newAge 新年龄
 @param newSex 新性别
 @return 是否更新成功
 */
- (BOOL)updateDataWithUserId:(NSString *)userId newName:(NSString *)newName newAge:(int)newAge newSex:(NSString *)newSex;

/**
 删除数据

 @param userId userId
 @return 是否删除成功
 */
- (BOOL)deleteDataWithUserId:(NSString *)userId;


/**
 查询usereId的最大值

 @return 返回最大id
 */
- (NSString *)queryMaxUserId;

@end
