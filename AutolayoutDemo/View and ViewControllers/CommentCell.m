//
//  CommentCell.m
//  AutolayoutDemo
//
//  Created by 孙 化育 on 15-1-7.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "CommentCell.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
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
    int commentLabelY = 66;
    for (int i = 0; i<comArr.count; i++) {
        NSDictionary *comment = [[dic allValues] objectAtIndex:i];
        NSString *commentText = [comment objectForKey:@"b"];
        NSLog(@"%@",commentText);
        if (i<comArr.count&&comArr.count>1) {
                //回复
        }else{
                //评论
            CGRect rect = [commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-16, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
            
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, commentLabelY, SCREEN_WIDTH-16, rect.size.height)];
            commentLabel.numberOfLines = 0;
            commentLabel.tag = 10;
            commentLabel.font = [UIFont systemFontOfSize:16];
            commentLabel.text = commentText;
            [self.contentView addSubview:commentLabel];
            
        }
    }
    
    
    
}









@end
