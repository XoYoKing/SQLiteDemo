//
//  SQLiteManger.m
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import "SQLiteManger.h"
#import <sqlite3.h>
#import "SQLiteModel.h"

@implementation SQLiteManger{
    sqlite3 *_sqlite;
}

/**
 获取SQLiteManger单例
 
 @return 单例对象
 */
+ (instancetype)sharedSQLiteManger{
    static SQLiteManger *theSQLiteManger = nil;
    
    if (theSQLiteManger == nil) {
        theSQLiteManger = [SQLiteManger new];
    }
    
    
    return theSQLiteManger;
}


/**
 打开数据库

 @return 是否打开成功
 */
- (BOOL)openTheDatabase{
    //获取数据库文件路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/sqlite.db"];

    //初始化sqlite
    _sqlite = nil;
    //打开数据库文件,如果文件存在,则直接打开,如果不存在则创建新的文件然后打开
    int result = sqlite3_open([filePath UTF8String], &_sqlite);
    
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败！");
        return NO;
    }
    NSLog(@"数据库打开成功！");
    return YES;
}

/**
 创建表
 
 @return 返回是否创建成功
 */
- (BOOL)createTable{
    //1.打开数据库
    if (![self openTheDatabase]) {
        return NO;
    }
    //2.创建SQL语句
    NSString *sqlStr = @"create table t_user(userId text primary key not null,username text,age integer,sex text)";
    
    //3.创建表
    char *error = nil;
    int result = sqlite3_exec(_sqlite, [sqlStr UTF8String], NULL, NULL, &error);
    
    if (result == SQLITE_OK) {
        NSLog(@"表格创建成功");
        sqlite3_close(_sqlite);
        return YES;
    }
    NSLog(@"表格创建失败");
    sqlite3_close(_sqlite);
    return NO;
}

/**
 插入数据
 
 @param userId userId
 @param username 用户名
 @param age 年龄
 @param sex 性别
 @return 是否插入成功
 */
- (BOOL)insertDataWithUserId:(NSString *)userId username:(NSString *)username age:(int)age sex:(NSString *)sex{
    //1.打开数据库
    
    if (![self openTheDatabase]) {
        return NO;
    }
    
    //2.编写sql语句 value值需要绑定   ？代替
    NSString *sqlStr = @"insert into t_user(userId,username,age,sex) values(?,?,?,?)";
    
    //3.编译sql语句
    
    //声明stmt
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &stmt, NULL);
    
    //编译不成功直接返回
    if (result != SQLITE_OK) {
        NSLog(@"编译失败");
        return NO;
    }
    
    //4.绑定参数
    sqlite3_bind_text(stmt, 1, [userId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [username UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 3, age);
    sqlite3_bind_text(stmt, 4, [sex UTF8String], -1, NULL);

    //5.执行sql语句
    
    int step = sqlite3_step(stmt);
    NSLog(@"返回的状态码是：%d  101是成功",step);
    if (step == SQLITE_ERROR) {
        NSLog(@"stmt执行失败！");
        //关闭数据库
        sqlite3_close(_sqlite);
        return NO;
    }else if (step == SQLITE_CONSTRAINT){
        //关闭数据库
        sqlite3_close(_sqlite);
        return NO;
    }
    
    
    //关闭编译后的stmt 关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite);
    NSLog(@"插入成功");
    return YES;
}

/**
 查询所有数据
 
 @return 返回查询的结果
 */
- (NSArray *)queryData{
    //1.打开数据库
    if (![self openTheDatabase]) {
        return nil;
    }
    
    //2.编写sql语言
    NSString *sqlStr = @"select * from t_user ";
    
    //3.编译sql语句
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        NSLog(@"编译失败！");
        
        return nil;
    }
    
    
    //4.绑定参数
    
    //5.执行sql sqlite3_step分步执行（单次）
    int step = sqlite3_step(stmt);
    
    if (step == SQLITE_ERROR) {
        NSLog(@"执行错误");
        
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    //判断执行该步后是否还有剩余数据
    while (step == SQLITE_ROW) {
        
        
        SQLiteModel *model = [[SQLiteModel alloc]init];
        
        //获取该该条数据的详细字段信息
        
        //userId
        model.userId = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
        //姓名
        model.username = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        //年龄
        model.age = sqlite3_column_int(stmt, 2);
        //性别
        model.sex = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
        
        [array addObject:model];
        step = sqlite3_step(stmt);
    }
    
    //6.关闭数据库，关闭编译后的stmt
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite);
    
    //返回数据数组
    return  array;
}

/**
 查询usereId的最大值
 
 @return 返回最大id
 */
- (NSString *)queryMaxUserId{
    //1.打开数据库
    if (![self openTheDatabase]) {
        return nil;
    }
    
    //2.编写sql语言
    NSString *sqlStr = @"select max(userId) from t_user ";
    //3.编译sql语句
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        NSLog(@"编译失败！");
        
        return nil;
    }
    
    
    //4.绑定参数
    
    //5.执行sql sqlite3_step分步执行（单次）
    int step = sqlite3_step(stmt);
    
    if (step == SQLITE_ERROR) {
        NSLog(@"执行错误");
        
        return nil;
    }
    

    NSString *maxUserId = @"error";
    //判断执行该步后是否还有剩余数据
    while (step == SQLITE_ROW) {
        const char *cString = (const char *)sqlite3_column_text(stmt, 0);
        if (cString) {
            maxUserId = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
        }else{
            maxUserId = @"NONE";
        }
        
        
        step = sqlite3_step(stmt);
    }
    
    //6.关闭数据库，关闭编译后的stmt
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite);
    
    //返回数据数组
    return  maxUserId;
}

/**
 更新数据
 
 @param userId userId
 @param newName 新名字
 @param newAge 新年龄
 @param newSex 新性别
 @return 是否更新成功
 */
- (BOOL)updateDataWithUserId:(NSString *)userId newName:(NSString *)newName newAge:(int)newAge newSex:(NSString *)newSex{
    //1.打开数据库
    if (![self openTheDatabase]) {
        return NO;
    }

    //2.编写sql语句 value值需要绑定   ？代替
    NSString *sqlStr = @"update t_user set username = ?,age = ?,sex = ? where userId = ? ";
    
    //3.编译sql语句
    
    //声明stmt
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &stmt, NULL);
    
    //编译不成功直接返回
    if (result != SQLITE_OK) {
        NSLog(@"编译失败");
        return NO;
    }
    
    //4.绑定参数
    sqlite3_bind_text(stmt, 1, [newName UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 2, newAge);
    sqlite3_bind_text(stmt, 3, [newSex UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [userId UTF8String], -1, NULL);
    
    
    //5.执行sql语句
    
    int step = sqlite3_step(stmt);
    if (step == SQLITE_ERROR) {
        NSLog(@"stmt执行失败！");
        //关闭数据库
        sqlite3_close(_sqlite);
        
        return NO;
    }
    
    //关闭数据库  关闭编译后的stmt
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite);
    
    NSLog(@"更新成功");
    return YES;
}

/**
 删除数据
 
 @param userId userId
 @return 是否删除成功
 */
- (BOOL)deleteDataWithUserId:(NSString *)userId{
    //1.打开数据库
    if (![self openTheDatabase]) {
        return NO;
    }
    
    //2.编写sql语句 value值需要绑定   ？代替
    NSString *sqlStr = @"delete from t_user where userId = ? ";

    //3.编译sql语句
    
    //声明stmt
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &stmt, NULL);
    
    //编译不成功直接返回
    if (result != SQLITE_OK) {
        NSLog(@"编译失败");
        return NO;
    }
    
    //4.绑定参数
    sqlite3_bind_text(stmt, 1, [userId UTF8String], -1, NULL);
    
    //5.执行sql语句
    int step = sqlite3_step(stmt);
    if (step == SQLITE_ERROR) {
        NSLog(@"stmt执行失败！");
        //关闭数据库
        sqlite3_close(_sqlite);
        return NO;
    }
    
    //关闭数据库  关闭编译后的stmt
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite);
    
    NSLog(@"删除成功");
    return YES;
}
@end
