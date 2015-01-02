//
//  NewsCenter.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsCenter.h"
#import "WTNetWork.h"
@implementation NewsCenter
//http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html


//获取新闻的分类
+(void)getNewsCategoty
{
    [WTRequestCenter getWithURL:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html"
                     parameters:nil
                         option:WTRequestCenterCachePolicyNormal
                       finished:^(NSURLResponse *response, NSData *data) {
                           NSDictionary *dict = [WTRequestCenter JSONObjectWithData:data];
                           NSLog(@"当前新闻分类 %@",dict);
                       } failed:^(NSURLResponse *response, NSError *error) {
                           
                       }];
}
@end
