//
//  CommentCell.m
//  AutolayoutDemo
//
//  Created by 孙 化育 on 15-1-7.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CommentCell.h"
#import "UIKit+WTRequestCenter.h"




@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithData:(NSDictionary *)dic{
    for (UIView *view in [self.contentView subviews]) {
        if (view.tag>0) {
            [view removeFromSuperview];
        }
    }
    NSArray *comArr = [dic allValues];
    int commentLabelY = 66+(int)(comArr.count-1)*3;
    int firstLabelY = 66+(int)(comArr.count-1)*3;
    for (int i = 0; i<comArr.count; i++) {
        NSDictionary *comment = [[dic allValues] objectAtIndex:comArr.count-1-i];
        NSString *commentText = [comment objectForKey:@"b"];
            //NSLog(@"%@",commentText);
        if (i<comArr.count-1&&comArr.count>1) {
                //回复
            int thisWidth = SCREEN_WIDTH-16-6*(comArr.count-i);
            int thisXPoint = 8+3*((int)comArr.count-i);
            CGRect rect = [commentText boundingRectWithSize:CGSizeMake(thisWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(thisXPoint, firstLabelY, thisWidth, rect.size.height+20)];
            view.layer.borderColor = [[UIColor blackColor] CGColor];
            view.layer.borderWidth = 1;
            view.tag = 11;
            view.backgroundColor = [UIColor yellowColor];
            
            UILabel *replyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
            replyNameLabel.textColor = [UIColor blueColor];
            replyNameLabel.text = [comment objectForKey:@"n"]?[comment objectForKey:@"n"]:@"火影网友";
            replyNameLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:replyNameLabel];
            
            UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, view.frame.size.width, rect.size.height)];
            replyLabel.numberOfLines = 0;
            replyLabel.font = [UIFont systemFontOfSize:16];
            replyLabel.text = [NSString stringWithFormat:@"%@",commentText];
            replyLabel.backgroundColor = [UIColor clearColor];
            [view addSubview:replyLabel];
            [self.contentView addSubview:view];
            commentLabelY = commentLabelY+rect.size.height+3+20;
        }else{
                //评论
            CGRect rect = [commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-16, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
            
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, commentLabelY, SCREEN_WIDTH-16, rect.size.height)];
            commentLabel.numberOfLines = 0;
            commentLabel.tag = 10;
            commentLabel.font = [UIFont systemFontOfSize:16];
            commentLabel.text = commentText;
            [self.contentView addSubview:commentLabel];
            if ([comment objectForKey:@"timg"]&&![[comment objectForKey:@"timg"] isEqual:[NSNull null]]) {
                [self.headImageView setImageWithURL:[comment objectForKey:@"timg"]];
            }else{
                self.headImageView.image = [UIImage imageNamed:@"comment_profile_mars"];
            }
            self.nameLabel.text = [comment objectForKey:@"n"]?[comment objectForKey:@"n"]:@"火影网友";
            self.addressLabel.text = [[[comment objectForKey:@"f"] componentsSeparatedByString:@"&nbsp;"] firstObject];
            self.commentCountLabel.text = [comment objectForKey:@"v"];
        }
    }
    
    
    
}









@end
