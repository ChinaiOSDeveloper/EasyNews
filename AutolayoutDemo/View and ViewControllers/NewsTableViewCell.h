//
//  NewsTableViewCell.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsTableViewCell;
@protocol NewsTableViewCellDataSource <NSObject>
-(NSString*)urlForNewsTableViewCell:(NewsTableViewCell*)cell;
-(NSString*)titleForNewsTableViewCell:(NewsTableViewCell*)cell;
-(NSString*)digestForNewsTableViewCell:(NewsTableViewCell*)cell;
-(NSString*)replyCountForNewsTableViewCell:(NewsTableViewCell*)cell;
@end

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,weak) id <NewsTableViewCellDataSource> dataSource;

@end


//file:///Users/song/https:/github.com/rs/EasyNews/AutolayoutDemo/View%20and%20ViewControllers/NewsTableViewCell.xib: warning: Attribute Unavailable: Automatic Preferred Max Layout Width is not available on iOS versions prior to 8.0
