//
//  NewsSegmentControl.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsSegmentControl : UIView
@property (nonatomic,strong) NSArray *newsTitles;


//当前索引
@property (nonatomic) NSUInteger selectedIndex;
@end
