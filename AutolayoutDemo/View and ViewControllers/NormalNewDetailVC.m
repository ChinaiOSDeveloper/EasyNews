//
//  NormalNewDetailVC.m
//  AutolayoutDemo
//
//  Created by song on 15/1/10.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NormalNewDetailVC.h"
#import "WTNetWork.h"
@interface NormalNewDetailVC () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    CGFloat _webViewHeight;
}
@property (strong, nonatomic) UIWebView *myWebView;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NormalNewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myWebView.hidden = YES;
    _webViewHeight = 0;
    self.myWebView = [[UIWebView alloc] init];
    _myWebView.delegate = self;
    _myWebView.backgroundColor = [UIColor redColor];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)useData
{
    [super useData];
    
    NSString *docid = [self.articleInfo valueForKey:@"docid"];
    NSDictionary *dict = self.newsData;
    NSString *body = [dict valueForKey:@"body"];
    dict = [dict valueForKey:docid];
    
    _myWebView.hidden = NO;
    
    CGRect frame = _myTableView.frame;
    frame.size.width = CGRectGetWidth(self.view.bounds);
    _myTableView.frame = frame;
    
    if ([_myWebView isLoading]) {
        [_myWebView stopLoading];
    }
    [_myWebView loadHTMLString:body baseURL:nil];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [UITableViewCell new];
    switch (indexPath.row) {
        case 0:
        {
            NSString  *title = [self.newsData valueForKeyPath:@"title"];
            cell.textLabel.text = title;
            
        }
            break;
        case 1:
        {
            [cell.contentView addSubview:_myWebView];
        }
            break;
            
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor redColor];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    _myWebView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), _webViewHeight);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (indexPath.row) {
        case 0:
        {
            height = 44;
        }
            break;
        case 1:
        {
            height = _webViewHeight;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    webView.scrollView.scrollEnabled = NO;
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _webViewHeight = height;
    [_myTableView reloadData];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
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
