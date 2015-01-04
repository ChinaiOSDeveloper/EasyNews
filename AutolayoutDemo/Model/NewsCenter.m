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
