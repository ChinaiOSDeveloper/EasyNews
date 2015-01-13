//
//  NewsImageCollectionViewCell.m
//  AutolayoutDemo
//
//  Created by SongWentong on 15/1/13.
//  Copyright (c) 2015年 song. All rights reserved.
//

#import "NewsImageCollectionViewCell.h"
#import "UIKit+WTRequestCenter.h"
@interface NewsImageCollectionViewCell() <UIScrollViewDelegate>
@end
@implementation NewsImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _imageScrollView.zoomScale = 1.0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_newsImageView) {
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _imageScrollView.delegate = self;
        [self.contentView addSubview:_imageScrollView];
        
        _imageScrollView.maximumZoomScale = 2.0;
        _imageScrollView.minimumZoomScale = 1.0;
        
        
        self.newsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageScrollView addSubview:_newsImageView];
    }
    _imageScrollView.frame = self.contentView.bounds;
    _newsImageView.frame = _imageScrollView.bounds;
//    self.contentView.backgroundColor = [UIColor greenColor];
//    NSLog(@"%@ layoutSubViews",self);
    

    
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_newsImageView) {
        return _newsImageView;
    }else
    {
        return nil;
    }
//    return _newsImageView;
}

@end
