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
#import "NewsTableView.h"
#import "UIKit+WTRequestCenter.h"
@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NewsTableViewDelegate,UIScrollViewDelegate>
{

}
//标题的CollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;
//新闻列表的CollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}


#pragma mark - Model
-(void)configModel
{
    self.dataList = nil;
}
#pragma mark - View
-(void)configView
{
//    self.title = @"网易";
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLabel.text = @"网易";
    titleLabel.font = [UIFont systemFontOfSize:25];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor WTcolorWithRed:220
                                                                             green:50
                                                                              blue:55
                                                                             alpha:1.0];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layout = nil;
    layout = (UICollectionViewFlowLayout*)_titleCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(50, 38);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _titleCollectionView.dataSource = self;
    _titleCollectionView.delegate = self;
    _titleCollectionView.showsHorizontalScrollIndicator = NO;
    self.titleCollectionView.collectionViewLayout = layout;

    
    _newsCollectionView.pagingEnabled = YES;
    layout = (UICollectionViewFlowLayout*)_newsCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
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
                               [self.newsCollectionView reloadData];
                               
                               
                               [self.titleCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (collectionView == _titleCollectionView) {
        count = [_newsTitles count];
    }
    if (collectionView==_newsCollectionView) {
        count = [_newsTitles count];
    }
    
    return count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (collectionView == _titleCollectionView) {
        cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:@"newsCell"
                forIndexPath:indexPath];
        NewsTitleCell *temp = (NewsTitleCell*)cell;
        temp.backgroundColor = [UIColor clearColor];
        
        NSDictionary *dict = _newsTitles[indexPath.row];
        
        temp.newsTitle.text = [dict valueForKey:@"cName"];
    }
    
    
    if (collectionView==_newsCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsTableCell"
                                                         forIndexPath:indexPath];
        NewsTableView *temp = (NewsTableView*)cell;
        temp.delegate = self;
        temp.backgroundColor = [UIColor grayColor];
        temp.newsDict = _newsTitles[indexPath.row];
        [temp reloadData];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _titleCollectionView) {

        [_titleCollectionView scrollToItemAtIndexPath:indexPath
                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                             animated:YES];
        
        
        [_newsCollectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
        
        
//        [_newsCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [_newsCollectionView performSelector:@selector(reloadItemsAtIndexPaths:)
                                  withObject:@[indexPath]
                                  afterDelay:0.5];
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSDictionary *dict = _newsTitles[indexPath.row];
//    NSLog(@"%@",dict);
//      24+20*2
    
    if (collectionView == _titleCollectionView) {
            return CGSizeMake(64, 38);
    }else
    {
        return _newsCollectionView.bounds.size;
    }

}

#pragma mark - NewsTableViewDelegate
-(void)newsTableView:(NewsTableView*)tableView selectArticleWithInfo:(NSDictionary*)info
{
    NewsDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailVC"];
    vc.articleInfo = info;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == _newsCollectionView) {
        CGPoint contentOffset = scrollView.contentOffset;
        CGFloat width = CGRectGetWidth(self.view.bounds);
        NSInteger page = contentOffset.x/width;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page
                                                     inSection:0];

        /*
        [_titleCollectionView scrollToItemAtIndexPath:indexPath
                                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                             animated:YES];
         */
        
        
        [_titleCollectionView selectItemAtIndexPath:indexPath
                                           animated:YES
                                     scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        
        
        
    }

    
    
    
    
    
    
}
@end
