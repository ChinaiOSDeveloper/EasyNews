//
//  CommentVC.m
//  AutolayoutDemo
//
//  Created by 孙 化育 on 15-1-6.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CommentVC.h"
#import "WTRequestCenter.h"

@interface CommentVC ()

@property (nonatomic,strong)NSArray *hotCommentsArray;

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
        //请求数据
    NSString *urlString = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/3g_bbs/%@/0/10/10/2/2",[_articleInfo objectForKey:@"docid"]];
    [WTRequestCenter getWithURL:urlString parameters:nil finished:^(NSURLResponse *response, NSData *data) {
            //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSDictionary *dic = [WTRequestCenter JSONObjectWithData:data];
            //NSLog(@"%@",str);
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
