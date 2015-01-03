//
//  NewsTableView.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsTableView;
@protocol NewsTableViewDelegate <NSObject>

-(void)newsTableView:(NewsTableView*)tableView selectArticleWithInfo:(NSDictionary*)info;

@end
@interface NewsTableView : UICollectionViewCell
@property (nonatomic,weak) id <NewsTableViewDelegate> delegate;

@property (nonatomic,strong) NSDictionary *newsDict;
-(void)reloadData;
@end
