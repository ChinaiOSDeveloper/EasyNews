//
//  NewsImageCollectionViewCell.m
//  AutolayoutDemo
//
//  Created by SongWentong on 15/1/13.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsImageCollectionViewCell.h"

@implementation NewsImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor redColor];
    
}

@end
