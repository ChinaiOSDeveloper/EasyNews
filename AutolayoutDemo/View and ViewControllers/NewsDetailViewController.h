//
//  NewsDetailViewController.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property (nonatomic,strong) NSDictionary *articleInfo; //传入的文章基本数据


@property (nonatomic,strong) NSDictionary *newsData; //从服务器访问的的文章详细数据

-(void)useData:(NSData*)data;
@end
