//
//  NewsTableView.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableView : UICollectionViewCell
@property (nonatomic,strong) NSDictionary *newsDict;
-(void)reloadData;
@end
