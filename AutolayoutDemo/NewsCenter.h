//
//  NewsCenter.h
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCenter : NSObject


//保存本地新闻栏目列表
+(void)saveLocalNewsColumn:(NSArray*)array;
//获取本地新闻栏目列表
+(void)localNewsColumnWithComplection:(void(^)(NSArray *array))completion;



@end
