//
//  NewsSegmentControl.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsSegmentControl.h"
#import "WTNetWork.h"
@interface NewsSegmentControl()
{
    UIScrollView *myScrollView;
    
    
}
@property (nonatomic,strong) NSMutableArray *buttonArray;
@end
@implementation NewsSegmentControl
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
        
        self.buttonArray = [NSMutableArray new];
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:myScrollView];

        self.selectedIndex = 0;
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self getNewsCategoty];
    
    if ([_buttonArray count]==0) {
        [self updateButtons];
    }
    
}

-(void)updateButtons
{
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button removeFromSuperview];
    }];
    [self.buttonArray removeAllObjects];

    
//    12 + n*29 + 12
    
    
    __block CGFloat x = 0;
    [_newsTitles enumerateObjectsUsingBlock:^(NSDictionary *infoDict, NSUInteger idx, BOOL *stop) {
        NSString *cName = [infoDict valueForKey:@"cName"];
//        NSString *cid = [infoDict valueForKey:@"cid"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, -64, (12+[cName length]*29+12), CGRectGetHeight(self.bounds));
        
        
        [button setTitle:cName forState:UIControlStateNormal];
        button.backgroundColor = [UIColor greenColor];
        [myScrollView addSubview:button];
        x = CGRectGetMaxX(button.frame);
    }];
    myScrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.bounds));
}

//获取新闻的分类
-(void)getNewsCategoty
{
    
    if ([_newsTitles count]==0) {
        [WTRequestCenter getWithURL:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html"
                         parameters:nil
                             option:WTRequestCenterCachePolicyCacheAndRefresh
                           finished:^(NSURLResponse *response, NSData *data) {
                               
                               NSArray *types = [WTRequestCenter JSONObjectWithData:data];
                               
                               self.newsTitles = types;
                               
                               [self updateButtons];
                               
                           } failed:^(NSURLResponse *response, NSError *error) {
                               
                           }];
    }

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
