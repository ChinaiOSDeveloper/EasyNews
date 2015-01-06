//
//  NewsTableView.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsTableView.h"
#import "NewsTableViewCell.h"
#import "WTNetWork.h"
@interface NewsTableView () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    
    BOOL _loadingMore;
    
}
@property (nonatomic, strong) NSMutableArray *dataList;
@end
@implementation NewsTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataList = [NSMutableArray new];
        
        _myTableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self addSubview:_myTableView];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
        
        _loadingMore = NO;
        
        UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell"
                                    bundle:nil];
        
        [_myTableView registerNib:nib
          forCellReuseIdentifier:@"NewsTableViewCell"];
        

    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    self.newsDict = nil;
    

}
-(void)reloadData
{

    
    [self reloadDataForce:NO];

}

-(void)reloadDataForce:(BOOL)force
{
    
    NSArray *tList = [_newsDict valueForKey:@"tList"];
    NSDictionary *dict = [tList firstObject];
    NSString *tid = [dict valueForKey:@"tid"];
    NSString *url = [self urlWithTid:tid];
    
    

    
    [WTRequestCenter getWithURL:url
                     parameters:nil
                         option:WTRequestCenterCachePolicyCacheAndWeb
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSDictionary *dict = [WTRequestCenter JSONObjectWithData:data];
                           
                           
                           NSArray *newsList = [[dict allValues] lastObject];
                           if ([newsList count]==0) {
                               //                                   如果没有从网络上得到数据，就不刷新
                               
                           }else
                           {
                               if ([_dataList isEqualToArray:newsList]) {
                                   return;
                               }
                               [_dataList removeAllObjects];
                               [self.dataList addObjectsFromArray:newsList];
                               
                               [_myTableView reloadData];
                           }

                       } failed:^(NSURLResponse *response, NSError *error) {
                           
                       }];

}

//分页的大小
static NSInteger pageSize = 20;

-(void)loadMore
{
    //如果在加载中，就取消加载更多
    if (_loadingMore) {
        return;
    }
//    加载中
    _loadingMore = YES;
    
    
    NSArray *tList = [_newsDict valueForKey:@"tList"];
    NSDictionary *dict = [tList firstObject];
    NSString *tid = [dict valueForKey:@"tid"];
    
    NSString *url = [self urlWithTid:tid range:NSMakeRange([_dataList count], pageSize)];
    
    
    [WTRequestCenter getWithURL:url
                     parameters:nil
                       finished:^(NSURLResponse *response, NSData *data) {
                           _loadingMore = NO;
                           
                           NSDictionary *dict = [WTRequestCenter JSONObjectWithData:data];
                           
                           
                           NSArray *newsList = [[dict allValues] lastObject];
                           [self.dataList addObjectsFromArray:newsList];
                           [_myTableView reloadData];
                           
                       } failed:^(NSURLResponse *response, NSError *error) {
                           _loadingMore = NO;
                       }];
    
}


-(NSString*)urlWithTid:(NSString*)tid
{
//http://c.m.163.com/nc/article/list/T1348648756099/0-20.html
    NSString *p1 = @"http://c.m.163.com/nc/article/list";
    NSString *p3 = @"0-20.html";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",p1,tid,p3];
    return url;
}

-(NSString*)urlWithTid:(NSString*)tid range:(NSRange)range
{
    NSString *p1 = @"http://c.m.163.com/nc/article/list";
    NSString *p3 = [NSString stringWithFormat:@"%lu-%lu.html",(unsigned long)range.location,range.location+range.length];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",p1,tid,p3];
    return url;
}




-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self reloadData];
    _myTableView.frame = self.bounds;


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
//    temp.textLabel.text = @"asdasdasd";
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier:@"pushToDetail"
//                              sender:_dataList[indexPath.row]];
    
    NSDictionary *dict = _dataList[indexPath.row];
    [self.delegate newsTableView:self
           selectArticleWithInfo:dict];
//    NSLog(@"%@",dict);
    
//    [self.delegate newsTableView:self
//            selectArticleWithtid:<#(NSString *)#>]
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataList count]<140) {
        if (_dataList.count - indexPath.row <10) {
            [self loadMore];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
