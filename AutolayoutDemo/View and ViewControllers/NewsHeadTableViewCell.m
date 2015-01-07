//
//  NewsHeadTableViewCell.m
//  AutolayoutDemo
//
//  Created by song on 15/1/6.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsHeadTableViewCell.h"
//#import "WTNetWork.h"
#import "UIKit+WTRequestCenter.h"
@interface NewsHeadTableViewCell()
{
    
//    图片数组
    NSMutableArray *_imageArray;
    
//    标题
    UILabel *_titleLabel;
}


@end
@implementation NewsHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imageArray = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_imageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [imageView removeFromSuperview];
    }];
    [_imageArray removeAllObjects];
    
    
    
    NSArray *imgextra = [_newsInfo valueForKey:@"imgextra"];
    NSUInteger count = [imgextra count];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    
    switch (count) {
            case 0:
        {
            NSString *imgsrc = [_newsInfo valueForKey:@"imgsrc"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            [imageView setImageWithURL:imgsrc];
            [self.contentView addSubview:imageView];
            [_imageArray addObject:imageView];

        }
            break;
        case 1:
        {
            [imgextra enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
                NSString *imgsrc = [info valueForKey:@"imgsrc"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                [imageView setImageWithURL:imgsrc];
                [self.contentView addSubview:imageView];
                [_imageArray addObject:imageView];
            }];
        }
            break;
        case 2:
        {
            [imgextra enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
                NSString *imgsrc = [info valueForKey:@"imgsrc"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2*idx, 0, width/2, height)];
                [imageView setImageWithURL:imgsrc];
                [self.contentView addSubview:imageView];
                [_imageArray addObject:imageView];
            }];
        }
            break;
        default:
            break;
    }
    

    
    
//    NSLog(@"%@",imgsrc);
}
@end
