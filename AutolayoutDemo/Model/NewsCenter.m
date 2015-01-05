//
//  NewsCenter.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsCenter.h"
#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
@implementation NewsCenter


static NSString *localColumnName = @"NewsCenter local column name";

+(void)saveLocalNewsColumn:(NSArray*)array
{
    assert(!array);
    [WTDataSaver saveData:[NSJSONSerialization dataWithJSONObject:array options:0 error:nil] withName:localColumnName];
}

+(void)localNewsColumnWithComplection:(void(^)(NSArray *array))completion
{
//    NSArray *result = nil;
    [WTDataSaver dataWithName:localColumnName
                   completion:^(NSData *data) {
                       
                       NSArray *array = [WTRequestCenter JSONObjectWithData:data];
                       
                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                           if (completion) {
                               completion(array);
                           }
                       }];

                   }];

    
}


//获取新闻的分类
+(void)getNewsCategoty
{
    
    
    //http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html
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






/*
 这是热门评论
 http://comment.api.163.com/api/json/post/list/new/hot/3g_bbs/AF661E1900963VRO/0/10/10/2/2

 
 这个是正常的评论
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/0/10/10/2/2
 
 分页这是10
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/10/10/10/2/2

 这是20
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/20/10/10/2/2
 */
