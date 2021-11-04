//
//  DCMoreGridCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "DCMoreGridCell.h"
// Vendors
#import <UIImageView+WebCache.h>
// Categories
#import "UIColor+DCColorChange.h"
// Others


#define Scale_Zoom self.dc_height *2/5

@interface DCMoreGridCell ()<UIGestureRecognizerDelegate>

@end

@implementation DCMoreGridCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.userInteractionEnabled = YES;
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_gridImageView];
    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = [UIFont fontWithName:PFRMedium size:13];;
    _gridLabel.textColor = RGB_COLOR(61, 61, 61);
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_gridLabel];
    
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.font = [UIFont systemFontOfSize:12];
    _tagLabel.backgroundColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tagLabel];
    

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
//    tap.delegate = self;
//    [self addGestureRecognizer:tap]; //点击
}
#pragma mark - 点击手势事件
- (void)tapEvent{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isPhone6below) {
            [make.top.mas_equalTo(self)setOffset:10];
            make.size.mas_equalTo(CGSizeMake(Scale_Zoom, Scale_Zoom));
        }else{
            [make.top.mas_equalTo(self)setOffset:15];
            make.size.mas_equalTo(CGSizeMake(Scale_Zoom+5, Scale_Zoom+5));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView.mas_bottom)setOffset:8];
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_gridImageView.mas_centerX)setOffset:10];
        [make.top.mas_equalTo(_gridImageView)setOffset:-7];;
        make.size.mas_equalTo(CGSizeMake(Scale_Zoom, 15));
    }];
}

- (void)setShowType:(BOOL)showType{
    _showType = showType;
    
    _tagLabel.backgroundColor = [UIColor whiteColor];
    
//    _tagLabel.textColor = [UIColor dc_colorWithHexString:_gridItem.gridColor];
//    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.left.mas_equalTo(_gridImageView.mas_centerX)setOffset:5];
//        make.top.mas_equalTo(_gridImageView);
//        make.size.mas_equalTo(CGSizeMake(35, 15));
//    }];

}

#pragma mark - Setter Getter Methods
- (void)setGridItem:(DCGridItem *)gridItem
{
    _gridItem = gridItem;
    
    _gridLabel.text = gridItem.gridTitle;
    _tagLabel.text = gridItem.gridTag;
    
    _tagLabel.hidden = (gridItem.gridTag.length == 0) ? YES : NO;
    _tagLabel.textColor = [UIColor dc_colorWithHexString:gridItem.gridColor];
    [DCSpeedy dc_changeControlCircularWith:_tagLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:_tagLabel.textColor canMasksToBounds:YES];
    
    if (_gridItem.iconImage.length == 0) return;
    _gridImageView.image = [UIImage imageNamed:_gridItem.iconImage];
}

#pragma mark - UIGestureRecognizerDelegate iOS当手势方法和tableview方法冲突时的解决方法
//iOS当手势方法和tableview方法冲突时的解决方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
    return  NO;
}

@end
