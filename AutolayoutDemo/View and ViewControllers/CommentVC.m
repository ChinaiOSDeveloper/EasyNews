//
//  CommentVC.m
//  AutolayoutDemo
//
//  Created by 孙 化育 on 15-1-6.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CommentVC.h"
#import "WTRequestCenter.h"

@interface CommentVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UITableView *_table;
}

@property (nonatomic,strong)NSArray *hotCommentsArray;

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
        //NSLog(@"%@",_articleInfo);
        //NSLog(@"%@",[_articleInfo objectForKey:@"source"]);
        //请求数据，先尝试从news_guonei8_bbs请求；
    NSString *urlString = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/news_guonei8_bbs/%@/0/10/10/2/2",[_articleInfo objectForKey:@"docid"]];
    NSLog(@"%@",urlString);
    [WTRequestCenter getWithURL:urlString parameters:nil finished:^(NSURLResponse *response, NSData *data) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [WTRequestCenter JSONObjectWithData:data];
        NSLog(@"---%@",str);
        if ([[dic objectForKey:@"code"] intValue] == -5) {
                //如果没有数据再从3g_bbs请求数据
            NSString *secUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/3g_bbs/%@/0/10/10/2/2",[_articleInfo objectForKey:@"docid"]];
            [WTRequestCenter getWithURL:secUrl parameters:nil finished:^(NSURLResponse *response, NSData *data) {
                NSDictionary *secDic = [WTRequestCenter JSONObjectWithData:data];
                self.hotCommentsArray = [secDic objectForKey:@"hotPosts"];
                NSString *secStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"---%@",secStr);
                [_table reloadData];
            } failed:^(NSURLResponse *response, NSError *error) {
                NSLog(@"请求失败%@",error.localizedDescription);
            }];
        }else{
            self.hotCommentsArray = [dic objectForKey:@"hotPosts"];
            [_table reloadData];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        NSLog(@"请求失败%@",error.localizedDescription);
    }];
    
}

#pragma mark- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotCommentsArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = [_hotCommentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [[dic objectForKey:@"1"] objectForKey:@"f"];
    
    cell.detailTextLabel.text = [[dic objectForKey:@"1"] objectForKey:@"b"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 5, 90, 40)];
    imgView.image = [[UIImage imageNamed:@"contentview_commentbacky"] stretchableImageWithLeftCapWidth:20 topCapHeight:22];
    [view addSubview:imgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 15, 70, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.text = @"热门跟帖";
    [view addSubview:label];
    
    return view;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 这是热门评论
 http://comment.api.163.com/api/json/post/list/new/hot/3g_bbs/AF661E1900963VRO/0/10/10/2/2
 
 //http://comment.api.163.com/api/json/post/list/new/hot/news_guonei8_bbs/AFBH38F60001124J/0/10/10/2/2
 
 
 这个是正常的评论 0-9
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/0/10/10/2/2
 
 分页这是 10-19
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/10/10/10/2/2
 
 这是   20-29
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/20/10/10/2/2
 
 30-39
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/AF661E1900963VRO/desc/30/10/10/2/2
 */

@end
