//
//  GLPHomeActivityCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeActivityCell.h"

@interface GLPHomeActivityCell ()

@property (nonatomic, strong) UIImageView *image;

@end

@implementation GLPHomeActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _image = [[UIImageView alloc] init];
    _image.userInteractionEnabled = YES;
    [self.contentView addSubview:_image];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_image addGestureRecognizer:tap];
    [self layoutIfNeeded];
}

- (void)tapClick
{
     NSArray *arr = self.activityModel.dataList;
    if (arr.count>0)
    {
        GLPHomeDataListModel*mode = [arr firstObject];
        if (self.activityblock) {
            self.activityblock(mode);
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.equalTo(0.184*kScreenW).priorityHigh();
    }];
    
}



#pragma mark - setter
- (void)setActivityModel:(GLPHomeDataModel *)activityModel
{
    _activityModel = activityModel;
    NSArray *arr = activityModel.dataList;
    if (arr.count>0)
    {
        GLPHomeDataListModel *mode = [arr firstObject];
        NSString *imageUrl = [[DCHelpTool shareClient] dc_imageUrl:mode.imgUrl];
        [_image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ppic"]];
    }
   
}
    

@end


