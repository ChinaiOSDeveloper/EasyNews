//
//  AtlasViewController.m
//  AutolayoutDemo
//
//  Created by song on 15/1/10.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "AtlasViewController.h"
#import "NewsImageCollectionViewCell.h"
#import "UIKit+WTRequestCenter.h"
@interface AtlasViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *myCollectionViewFlowLayout;
@property (strong, nonatomic) NSArray *photos;
@end

@implementation AtlasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myCollectionViewFlowLayout.itemSize = self.view.bounds.size;
//    _myCollectionViewFlowLayout.minimumInteritemSpacing = 0;
//    _myCollectionViewFlowLayout.minimumLineSpacing = 0;
//    _myCollectionViewFlowLayout.itemSize = CGSizeMake(320, 400);
    
    
    UINib *nib = [UINib nibWithNibName:@"NewsImageCollectionViewCell"
                                bundle:nil];
    [self.myCollectionView registerNib:nib
        forCellWithReuseIdentifier:@"NewsImageCollectionViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)useData
{
    [super useData];

    NSArray *photos = [self.newsData valueForKey:@"photos"];
    self.photos = photos;
    [_myCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsImageCollectionViewCell"
                                                     forIndexPath:indexPath];
    NewsImageCollectionViewCell *temp = (NewsImageCollectionViewCell*)cell;
    temp.imageInfo = _photos[indexPath.row];
    NSString *imgurl = [temp.imageInfo valueForKey:@"imgurl"];
    [temp.newsImageView setImageWithURL:imgurl];
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size = self.view.bounds.size;
//    size = collectionView.bounds.size;
//    size = CGSizeMake(300, 300);
    return size;
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
