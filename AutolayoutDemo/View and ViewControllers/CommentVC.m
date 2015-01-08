//
//  CommentVC.m
//  AutolayoutDemo
//
//  Created by 孙 化育 on 15-1-6.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CommentVC.h"
#import "WTRequestCenter.h"
#import "CommentCell.h"

@interface CommentVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UITableView *_table;
}

@property (nonatomic,strong)NSArray *hotCommentsArray;

@end

@implementation CommentVC


#pragma mark- view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_table registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"comment"];
        //NSLog(@"%@",_articleInfo);
        //NSLog(@"%@",[_articleInfo objectForKey:@"source"]);
        //请求数据，先尝试从news_guonei8_bbs请求；
    NSString *urlString = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/news_guonei8_bbs/%@/0/10/10/2/2",[_articleInfo objectForKey:@"docid"]];
        //NSLog(@"%@",urlString);
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
                if ([_hotCommentsArray isEqual:[NSNull null]]) {

                }else
                {
                    NSString *secStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"---%@",secStr);
                    [_table reloadData];
                }
                
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
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    
    NSDictionary *dic = [_hotCommentsArray objectAtIndex:indexPath.row];
    [cell setContentWithData:dic];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_hotCommentsArray objectAtIndex:indexPath.row];
    
    return [self calculateHeightForData:dic];
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

#pragma mark- commonMethod
- (CGFloat)calculateHeightForData:(NSDictionary *)dic{
    NSArray *comArr = [dic allValues];
    int commentLabelY = 66+(int)(comArr.count-1)*3;
    
    for (int i = 0; i<comArr.count; i++) {
        NSDictionary *comment = [[dic allValues] objectAtIndex:comArr.count-1-i];
        NSString *commentText = [comment objectForKey:@"b"];
        NSLog(@"%@",commentText);
        if (i<comArr.count-1&&comArr.count>1) {
            int thisWidth = SCREEN_WIDTH-16-6*(comArr.count-i);
            CGRect rect = [commentText boundingRectWithSize:CGSizeMake(thisWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];

            commentLabelY = commentLabelY+rect.size.height+3+20;
        }else{
                //评论
            CGRect rect = [commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-16, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
            
            commentLabelY = commentLabelY+rect.size.height;
        }
    }
    return commentLabelY+5;
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
