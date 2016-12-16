//
//  PopViewTableViewController.m
//  newsPopView
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import "PopViewTableViewController.h"
#import "PopViewCell.h"
#import "KGDislikeView.h"
#import "DislikeModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PopViewModel.h"
#import "AppDelegate.h"
#import "PopViewShowController.h"


@interface PopViewTableViewController ()<UITableViewDelegate,UITableViewDataSource,AddrListEditTableViewCellDelegate>
@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *newsArray;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) UITableView *popTableView;
@end

@implementation PopViewTableViewController
#define MAXFLOAT    0x1.fffffep+127f
- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

static NSString * const PopViewCellID = @"newsCell";
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUptableView];
     [self setUpRefresh];

}


- (void) setUptableView
{
    /**注册cell*/
    self.automaticallyAdjustsScrollViewInsets = NO;
    //table view 设置
    self.popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.popTableView.delegate = self;
    self.popTableView.dataSource = self;
    
    self.popTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //
    self.popTableView.scrollIndicatorInsets = self.popTableView.contentInset;
    [self.popTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PopViewCell class]) bundle:nil] forCellReuseIdentifier:PopViewCellID];
     self.popTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.popTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delNews) name:kDelNotification object:nil];
    [self.view addSubview:self.popTableView];
}
- (void) setUpRefresh
{
    self.popTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewsTopic)];
    self.popTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.popTableView.mj_header beginRefreshing];
}

- (void) loadNewsTopic
{
    self.page = 1;
    [self.popTableView.mj_header endRefreshing];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    
    NSString *string = [timeString substringToIndex:10];
    NSLog(@"timeString--%@",string);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sort"] = @"asc";
    parameters[@"page"] = @(self.page);
    parameters[@"pagesize"] = @(20);
    parameters[@"time"] = @"1418816972";
    parameters[@"key"] = @"b0b13496421e88aab3195e6364197930";
    
    NSString *url = @"http://japi.juhe.cn/joke/content/list.from";
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"responseObject[result][data]--%@",responseObject[@"result"][@"data"]);
        
        self.newsArray = [PopViewModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"data"]];
        [self.popTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"error---%@",error);
    }];
    
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.newsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopViewCellID forIndexPath:indexPath];
    cell.newsTopic = self.newsArray[indexPath.row];
   
    ((PopViewCell*)cell).index = indexPath.row;
    ((PopViewCell*)cell).delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopViewModel *news = self.newsArray[indexPath.row];
    /**文字的Y值*/
    CGFloat textY = 15;
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 52);
    CGFloat textH = [news.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
    CGFloat cellHight = textY + textH +60;
    
    return cellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    PopViewModel *popModel = self.newsArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PopViewShowController *popShowVC = [[PopViewShowController alloc] init];
    popShowVC.jokeStr = popModel.content;
    [self.navigationController pushViewController:popShowVC animated:YES];
    
}

#pragma mark - 实现AddrEditCell的代理
//删除助理
-(void)onAddrDelWithIndex:(NSInteger)index
{
    self.index = index;
    
}

- (void) delNews
{
    [self onAddrDelWithIndex:self.index];
    [self.newsArray removeObjectAtIndex:self.index];
    [self.popTableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
