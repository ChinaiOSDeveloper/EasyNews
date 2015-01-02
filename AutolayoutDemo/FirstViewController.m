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
@interface FirstViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{

}


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
    
    
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

#pragma mark - 数据

/*
 T1348647853363  这个应该是头条
 */
-(void)reloadData
{

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
    return [_newsTitles count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collect"
                                                  forIndexPath:indexPath];
    NewsTitleCell *temp = (NewsTitleCell*)cell;
    temp.newsTitle.text = @"sadasda";
    return cell;
    
}
#pragma mark - UICollectionViewDelegate


@end
