//
//  NewsImageCollectionViewCell.h
//  AutolayoutDemo
//
//  Created by SongWentong on 15/1/13.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsImageCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) NSDictionary *imageInfo;
@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *newsImageView;


@end
