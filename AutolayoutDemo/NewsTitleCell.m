//
//  NewsTitleCell.m
//  AutolayoutDemo
//
//  Created by song on 15/1/2.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsTitleCell.h"

@implementation NewsTitleCell

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *textColor;
    UIFont *font;
    if (selected) {
        textColor = [UIColor redColor];
        font = [UIFont systemFontOfSize:18];
    }else
    {
        textColor = [UIColor blackColor];
        font = [UIFont systemFontOfSize:14];
    }
    
    
    [UIView animateWithDuration:0.45
                          delay:9
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _newsTitle.textColor = textColor;
                         _newsTitle.font = font;
                     } completion:nil];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
}
@end
