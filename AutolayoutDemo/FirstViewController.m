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
#import "NewsTitleCell.h"
@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

}

@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;

//新闻标题
@property (nonatomic,strong) NSArray *newsTitles;

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

    [self reloadData];

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
    
    
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layout = nil;
    layout = (UICollectionViewFlowLayout*)_titleCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    NSLog(@"%@",layout);
    
    _titleCollectionView.backgroundColor = [UIColor redColor];
    _titleCollectionView.dataSource = self;
    _titleCollectionView.delegate = self;
}

#pragma mark - 数据

/*
 T1348647853363  这个应该是头条
 */
-(void)reloadData
{
    [self getNewsCategoty];
}

//获取新闻的分类
-(void)getNewsCategoty
{
    
    if ([_newsTitles count]==0) {
        [WTRequestCenter getWithURL:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html"
                         parameters:nil
                             option:WTRequestCenterCachePolicyCacheAndRefresh
                           finished:^(NSURLResponse *response, NSData *data) {
                               
                               NSArray *types = [WTRequestCenter JSONObjectWithData:data];
                               
                               self.newsTitles = types;
                               
                               [self.titleCollectionView reloadData];
                               
                           } failed:^(NSURLResponse *response, NSError *error) {
                               
                           }];
    }
    
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [_newsTitles count];
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsCell"
                                  forIndexPath:indexPath];
    NewsTitleCell *temp = (NewsTitleCell*)cell;
    temp.newsTitle.text = @"sadasda";
    return cell;
    
}
#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 38);
}

@end
