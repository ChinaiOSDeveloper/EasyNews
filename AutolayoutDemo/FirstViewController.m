//
//  FirstViewController.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "FirstViewController.h"
#import "NewsTableViewCell.h"
#import "WTNetWork.h"
#import "NewsDetailViewController.h"

@interface FirstViewController () <UITableViewDataSource,UITableViewDelegate>
{

}

@property (nonatomic, strong) NSArray *dataList;
@end

@implementation FirstViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configModel];
    [self configView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_dataList count]==0) {
        [self reloadData];
    }
}


#pragma mark - Model
-(void)configModel
{
    self.dataList = nil;
}
#pragma mark - View
-(void)configView
{
    self.title = @"网易";
    
    
    
    
    UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell"
                                bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"NewsTableViewCell"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

#pragma mark - 数据

/*
 T1348647853363  这个应该是头条
 */
-(void)reloadData
{
    NSString *url = @"http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html";
    
    [WTRequestCenter getWithURL:url
                     parameters:nil
                         option:WTRequestCenterCachePolicyCacheAndWeb
                       finished:^(NSURLResponse *response, NSData *data) {
                           
                           NSArray *result = [WTRequestCenter JSONObjectWithData:data];
                           self.dataList = [result valueForKey:@"T1348647853363"];
                           [self.tableView reloadData];
                           
//                           AESTEEJV00014JB5
//                           http://c.m.163.com/nc/article/AEVCOFPO0001124J/full.html
                       } failed:^(NSURLResponse *response, NSError *error) {
                           
                       }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _dataList.count;
    if (count == 0) {
        tableView.hidden = YES;
    }else
    {
        tableView.hidden = NO;
    }
    return count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
    
    NewsTableViewCell *temp = (NewsTableViewCell*)cell;
    temp.newsData = _dataList[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushToDetail"
                              sender:_dataList[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - UIStoryboardSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[NewsDetailViewController class]]) {
        NewsDetailViewController *temp = (NewsDetailViewController*)destinationViewController;
        temp.articleInfo = sender;
    }
}
@end
