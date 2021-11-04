//
//  GLBGuideBannerCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGuideBannerCell.h"

@interface GLBGuideBannerCell ()



@end

@implementation GLBGuideBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.placeholderImage = [UIImage imageNamed:@"ppic"];
    [_scrollView dc_cornerRadius:5];
    _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        // 按钮点击
//        if (weakSelf.bannerViewBlock) {
//            weakSelf.bannerViewBlock([weakSelf.dataArray[currentIndex] adLinkUrl]);
//        }
    };
    [self.contentView addSubview:_scrollView];
    
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo((kScreenW - 8*2)*0.3);
    }];
}

@end
