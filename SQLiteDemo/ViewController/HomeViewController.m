//
//  HomeViewController.m
//  SQLiteDemo
//
//  Created by 闵哲 on 2017/5/13.
//  Copyright © 2017年 Gunmm. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "AddUserViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_theTableView;
    NSArray *_dataList;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    //创建TableView
    [self createTableView];
    
    //从数据库拿数据
    [self getDataFromTheDatabase];
    // Do any additional setup after loading the view.
}


- (void)initNavigationBar{
    self.title = @"列表";
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newBtnClicked)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *hasTable = [userDefaults objectForKey:@"hasTable"];
    if (![hasTable isEqualToString:@"1"]) {
        [userDefaults setObject:@"1" forKey:@"hasTable"];
        [[SQLiteManger sharedSQLiteManger] createTable];
    }

}

- (void)newBtnClicked{
    AddUserViewController *addVc = [AddUserViewController new];
    [self.navigationController pushViewController:addVc animated:YES];
}


- (void)getDataFromTheDatabase{
    // Do any additional setup after loading the view, typically from a nib.
    //调用封装好的方法  拿数据
    _dataList = [[SQLiteManger sharedSQLiteManger] queryData];

       
    [_theTableView reloadData];
}
- (void)createTableView{
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    [self.view addSubview:_theTableView];
}


#pragma mark----delegate  dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HomeTableViewCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell methodForRefresh:^{
        [self getDataFromTheDatabase];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



- (void)viewWillAppear:(BOOL)animated{
    //从数据库拿数据
    [self getDataFromTheDatabase];
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
