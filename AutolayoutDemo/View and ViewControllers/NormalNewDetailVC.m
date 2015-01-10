//
//  NormalNewDetailVC.m
//  AutolayoutDemo
//
//  Created by song on 15/1/10.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NormalNewDetailVC.h"
#import "WTNetWork.h"
@interface NormalNewDetailVC ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation NormalNewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)useData:(NSData*)data
{
    [super useData:data];
    
    NSString *docid = [self.articleInfo valueForKey:@"docid"];
    NSDictionary *dict = [WTRequestCenter JSONObjectWithData:data];
    dict = [dict valueForKey:docid];
    NSString *body = [dict valueForKey:@"body"];
    dict = [dict valueForKey:docid];
    
    [_myWebView loadHTMLString:body baseURL:nil];
    
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
