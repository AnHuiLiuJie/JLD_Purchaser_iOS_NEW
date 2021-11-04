//
//  ReasonEvaluationView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/24.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "ReasonEvaluationView.h"
#import "HAppraiseTagsModel.h"

@interface ReasonEvaluationView ()

// 标签按钮的数组
@property (nonatomic, strong) NSMutableArray *appraiseBtnArray;

//标签数组(存标签model)
@property (nonatomic, strong) NSMutableArray *tagModelArray;

@end

@implementation ReasonEvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (NSMutableArray *)appraiseBtnArray
{
    if (_appraiseBtnArray == nil) {
        _appraiseBtnArray = [NSMutableArray array];
    }
    return _appraiseBtnArray;
}

- (NSMutableArray *)tagModelArray
{
    if (_tagModelArray == nil) {
        _tagModelArray = [NSMutableArray array];
        
        HAppraiseTagsModel *model1 = [[HAppraiseTagsModel alloc] init];
        model1.appraiseTagsId = @100;
        model1.name = @"回复不及时";
        model1.isSelected = @"NO";
        
        HAppraiseTagsModel *model2 = [[HAppraiseTagsModel alloc] init];
        model2.appraiseTagsId = @10;
        model2.name = @"服务态度差";
        model2.isSelected = @"NO";
        
        HAppraiseTagsModel *model3 = [[HAppraiseTagsModel alloc] init];
        model3.appraiseTagsId = @1;
        model3.name = @"客服对业务不熟悉";
        model3.isSelected = @"NO";
        
        [_tagModelArray addObject:model1];
        [_tagModelArray addObject:model2];
        [_tagModelArray addObject:model3];
    }
    return _tagModelArray;
}

- (NSMutableArray *)selectTagsArray
{
    if (_selectTagsArray == nil) {
        _selectTagsArray = [NSMutableArray array];
    }
    return _selectTagsArray;
}

- (void)setMark:(NSUInteger)mark{
    ////不满意原因：100-回复不及时，010-服务态度差，001-客服对业务不熟悉（111-表示三个原因都选中）
    HAppraiseTagsModel *model1 = [self.tagModelArray objectAtIndex:0];
    HAppraiseTagsModel *model2 = [self.tagModelArray objectAtIndex:1];
    HAppraiseTagsModel *model3 = [self.tagModelArray objectAtIndex:2];
    model1.isSelected = @"NO";
    model2.isSelected = @"NO";
    model3.isSelected = @"NO";
    if (mark == 1) {
        model1.isSelected = @"YES";
    }else if(mark == 2){
        model2.isSelected = @"YES";
    }else if(mark == 3){
        model3.isSelected = @"YES";
    }else if(mark == 12){
        model1.isSelected = @"YES";
        model2.isSelected = @"YES";
    }else if(mark == 13){
        model1.isSelected = @"YES";
        model3.isSelected = @"YES";
    }else if(mark == 23){
        model2.isSelected = @"YES";
        model3.isSelected = @"YES";
    }else if(mark == 123){
        model1.isSelected = @"YES";
        model2.isSelected = @"YES";
        model3.isSelected = @"YES";
    }else{
        model1.isSelected = @"NO";
        model2.isSelected = @"NO";
        model3.isSelected = @"NO";
    }
    // 设置标签按钮的title
    [self setTagsButtonTitle];
}

- (void)setupUI{
    //self.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];

    self.backgroundColor = [UIColor whiteColor];
    int i;
    NSInteger tag = 1;
    for (i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(255, 153, 0, 1) forState:UIControlStateSelected];
        //[button setBackgroundImage:[self createImageWithColor:RGBACOLOR(255, 255, 255,1)] forState:UIControlStateNormal];
        CGFloat buttonW = 120;
        CGFloat buttonH = 35;
        CGFloat spaceH = (kHDScreenWidth - 20 - buttonW*2)/3;
        CGFloat spaceV = (self.dc_height - buttonH*2)/3;
        if (i==2) {
            button.frame = CGRectMake((kHDScreenWidth-buttonW-30)/2, spaceV +(buttonH + spaceV), buttonW+30, buttonH);
            button.tag = tag;

        }else{
            button.tag = tag;
            button.frame = CGRectMake(spaceH + (buttonW + spaceH)*i, spaceV , buttonW, buttonH);
        }
        NSLog(@"tag %ld ",tag);

        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGBACOLOR(153, 153, 153, 1).CGColor;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.appraiseBtnArray addObject:button];
        tag++;
    }
}

// Quartz2D绘制一张颜色图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected == YES) {
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(255, 153, 0, 1)];
        [self tagsButton:button removeOrAddTagModel:YES];
    } else {
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(153, 153, 153, 1)];
        [self tagsButton:button removeOrAddTagModel:NO];
    }
    
    [self setTagsButtonTitle];
}

- (void)tagsButton:(UIButton *)button buttonWithBorderWidth:(CGFloat)width buttonWithborderColor:(UIColor *)color
{
    button.layer.borderWidth = width;
    button.layer.borderColor = color.CGColor;
}

- (void)tagsButton:(UIButton *)button removeOrAddTagModel:(BOOL)judge
{
    for (int i = 0; i < self.tagModelArray.count; i ++) {
        HAppraiseTagsModel *model = [self.tagModelArray objectAtIndex:i];
        if (button.tag == i + 1) {
            if (judge) {
                model.isSelected = @"YES";
                [self.selectTagsArray addObject:model];
            } else {
                model.isSelected = @"NO";
                [self.selectTagsArray removeObject:model];
            }
        }
    }
}


- (void)setTagsButtonState
{
    for (UIButton *button in self.appraiseBtnArray) {
        button.selected = NO;
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(153, 153, 153, 1)];
    }
}

- (void)setTagsButtonTitle
{
    [self.selectTagsArray removeAllObjects];
    for (int i = 0; i < self.tagModelArray.count; i ++) {
        HAppraiseTagsModel *model = [self.tagModelArray objectAtIndex:i];

        UIButton *button = [self.appraiseBtnArray objectAtIndex:i];
        BOOL isSelected = [model.isSelected isEqualToString:@"YES"];
        button.selected = isSelected;
        [button setTitle:model.name forState:UIControlStateNormal];
        if (isSelected) {
            [self.selectTagsArray addObject:model];
            [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(255, 153, 0, 1)];
        } else {
            //[self.selectTagsArray removeObject:model];
            [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(153, 153, 153, 1)];
        }

    }
    
    if ([self.delegate respondsToSelector:@selector(dc_evaluationTagSelectWithArray:)]) {
        [self.delegate dc_evaluationTagSelectWithArray:self.selectTagsArray];
    }
}

@end
