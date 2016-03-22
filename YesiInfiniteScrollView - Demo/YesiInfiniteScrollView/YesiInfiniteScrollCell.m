//
//  YesiInfiniteScrollCell.m
//  YesiInfiniteScrollView - Demo
//
//  Created by 黄丽萍 on 16/3/21.
//  Copyright © 2016年 黄丽萍. All rights reserved.
//  If not use xib, please implement initWithFrame & layoutSubviews

#import "YesiInfiniteScrollCell.h"
@interface YesiInfiniteScrollCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YesiInfiniteScrollCell

- (void)awakeFromNib {
    self.imageView.image = self.dataModel.image;
    
}

@end
