//
//  NewsDetailViewController.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "WTNetWork.h"
#import "CommentVC.h"
@interface NewsDetailViewController ()
{

}






@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    
}

-(void)loadData
{
    if (!_newsData) {
        NSString *docid = [_articleInfo valueForKey:@"docid"];
        NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",docid];
        [WTRequestCenter getWithURL:url
                         parameters:nil
                             option:WTRequestCenterCachePolicyCacheAndWeb
                           finished:^(NSURLResponse *response, NSData *data)
        {
            [self useData:data];

        }
                             failed:^(NSURLResponse *response, NSError *error)
        {
                               
        }];
    }

}


-(void)useData:(NSData*)data
{
    
    NSString *docid = [_articleInfo valueForKey:@"docid"];
    NSDictionary *dict = [WTRequestCenter JSONObjectWithData:data];
    dict = [dict valueForKey:docid];
    
    NSNumber *replyCount = [dict valueForKey:@"replyCount"];
    NSString *replyCountString = [NSString stringWithFormat:@"%@评论",replyCount];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:replyCountString
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(commentButtonPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    

}


//评论点击
-(void)commentButtonPressed:(id)sender
{
    CommentVC *vc = [[CommentVC alloc] init];
    vc.articleInfo = _articleInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
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
