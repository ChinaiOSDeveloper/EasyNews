//
//  NewsTableViewCell.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIKit+WTRequestCenter.h"
#import "WTNetWork.h"
@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsContent;
@property (weak, nonatomic) IBOutlet UILabel *numberOfReplyLabel;

@end
@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


-(void)prepareForReuse
{
    [super prepareForReuse];
//    _newsImage.image = nil;
//    WTURLRequestOperation *operation = _newsImage.wtImageRequestOperation;
//    [operation cancel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *imgsrc = [_newsData valueForKey:@"imgsrc"];
    [_newsImage setImageWithURL:imgsrc];
    
    NSString *title = [_newsData valueForKey:@"title"];
    _newsTitle.text = title;
    
    NSString *digest = [_newsData valueForKey:@"digest"];
    _newsContent.text = digest;
    
    NSNumber *replyCount = [_newsData valueForKey:@"replyCount"];
    _numberOfReplyLabel.text = [NSString stringWithFormat:@"%@跟帖",replyCount];
    
    
}

@end












