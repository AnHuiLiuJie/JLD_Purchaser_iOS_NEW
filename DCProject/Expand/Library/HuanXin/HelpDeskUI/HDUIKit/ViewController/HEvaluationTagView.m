//
//  HEvaluationTagView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/8/24.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HEvaluationTagView.h"
#import "HAppraiseTagsModel.h"

@interface HEvaluationTagView ()

// 扩展中的标签数组
@property (nonatomic, strong) NSArray *appraiseTagsArray;
// 标签按钮的数组
@property (nonatomic, strong) NSMutableArray *appraiseBtnArray;
// 标记
@property (nonatomic, assign) NSUInteger mark;
// 当前数组中元素的位置
@property (nonatomic, assign) NSUInteger currentArrayNum;
//标签数组(存标签model)
@property (nonatomic, strong) NSMutableArray *tagModelArray;

@end

@implementation HEvaluationTagView

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

- (NSArray *)appraiseTagsArray
{
    if (_appraiseTagsArray == nil) {
        _appraiseTagsArray = [NSMutableArray array];
    }
    return _appraiseTagsArray;
}

- (NSMutableArray *)tagModelArray
{
    if (_tagModelArray == nil) {
        _tagModelArray = [NSMutableArray array];
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

- (void)setupUI{
    //self.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
    
    UILabel *_textLabel = [[UILabel alloc] init];
    _textLabel.text = @"本次问题";
    _textLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _textLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _textLabel.frame = CGRectMake(0, 0, self.dc_width, 30);
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    int i;
    for (i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(255, 153, 0, 1) forState:UIControlStateSelected];
        button.tag = i+1;

        CGFloat buttonW = 100;
        CGFloat buttonH = 35;
        CGFloat spaceH = (self.dc_width - buttonW*2)/3;
        CGFloat spaceV = (self.dc_height - buttonH*2)/3+_textLabel.dc_height;
        button.frame = CGRectMake(spaceH + (buttonW + spaceH+3)*i, spaceV , buttonW, buttonH);

        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = RGBACOLOR(153, 153, 153, 1).CGColor;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.appraiseBtnArray addObject:button];
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
    for (int i = 0; i < self.tagModelArray.count; i ++) {
        HAppraiseTagsModel *model = [self.tagModelArray objectAtIndex:i];
        model.isSelected = @"NO";
        if (i==(button.tag-1) && button.selected) {
            model.isSelected = @"YES";
        }
    }
    [self setTagsButtonTitle];
    
    if (button.selected == YES) {
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(255, 153, 0, 1)];
        [self tagsButton:button removeOrAddTagModel:YES];
    } else {
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:RGBACOLOR(153, 153, 153, 1)];
        [self tagsButton:button removeOrAddTagModel:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(evaluationTagSelectWithArray:)]) {
        [self.delegate evaluationTagSelectWithArray:self.selectTagsArray];
    }
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
                [self.selectTagsArray addObject:[self.tagModelArray objectAtIndex:i]];
            } else {
                model.isSelected = @"NO";
                [self.selectTagsArray removeObject:[self.tagModelArray objectAtIndex:i]];
            }
        }
    }
}

- (void)setEvaluationDegreeModel:(HEvaluationDegreeModel *)evaluationDegreeModel
{
    _evaluationDegreeModel = evaluationDegreeModel;
    // 切换星数时，清空选择标签按钮数组
    if(self.selectTagsArray.count > 0) {
        [self.selectTagsArray removeAllObjects];
        if ([self.delegate respondsToSelector:@selector(evaluationTagSelectWithArray:)]) {
            [self.delegate evaluationTagSelectWithArray:self.selectTagsArray];
        }
    }

    // 切换星数时，按钮重置为未被选中状态
    [self setTagsButtonState];
    
    // 记录扩展中评价标签的数组
    self.appraiseTagsArray = evaluationDegreeModel.appraiseTags;
    // 切换星数时，清空标签model数组
    if (self.tagModelArray.count > 0) {
        [self.tagModelArray removeAllObjects];
    }
    // 遍历扩展数组，转换为model存进数组 (如果扩展里面没有标签，把标签按钮都隐藏，清空数据)
    if (self.appraiseTagsArray.count == 0) {
        for (UIButton *button in self.appraiseBtnArray) {
            button.hidden = YES;
        }
        [self.tagModelArray removeAllObjects];
    } else {
        for (NSDictionary *dict in self.appraiseTagsArray) {
            HAppraiseTagsModel *atm = [HAppraiseTagsModel appraiseTagsWithDict:dict];
            [self.tagModelArray addObject:atm];
        }
        for (int i = 0; i < self.tagModelArray.count; i ++) {
            UIButton *button = self.appraiseBtnArray[i];
            button.hidden = NO;
        }
    }
    
    for (int i = 0; i < self.tagModelArray.count; i++) {
        HAppraiseTagsModel *atm = self.tagModelArray[i];
        if (atm.name.length > 7) {
            UIButton *button = self.appraiseBtnArray[i];
            button.titleLabel.font = [UIFont systemFontOfSize:8];
        } else {
            UIButton *button = self.appraiseBtnArray[i];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    
    //与当前扩展中评价标签的数组对比，判断加星还是减星
    if (self.mark < self.appraiseTagsArray.count && self.mark) {
        NSUInteger num = self.appraiseTagsArray.count - self.mark;
        for (int i = 0; i < num; i++) {
            UIButton *button = [self.appraiseBtnArray objectAtIndex:i + self.mark];
            button.hidden = NO;
        }
        self.mark = _appraiseTagsArray.count;
    } else {
        // 计算标签按钮数目与扩展中标签数组中标签数目的差值
        NSUInteger num = self.appraiseBtnArray.count - evaluationDegreeModel.appraiseTags.count;
        
        // 有多少差值就隐藏几个按钮
        for (int i = 0; i < num; i++) {
            UIButton *button = [self.appraiseBtnArray objectAtIndex:5-i];
            button.hidden = YES;
            self.currentArrayNum = 5 - i - 1;
        }
        // 记录当前标签按钮数组中隐藏按钮之后的，数组元素的位置
        self.mark = self.currentArrayNum;
    }
    // 设置标签按钮的title
    [self setTagsButtonTitle];
}

- (void)setTagsButtonState
{
    for (UIButton *button in self.appraiseBtnArray) {
        button.selected = NO;
        [self tagsButton:button buttonWithBorderWidth:1 buttonWithborderColor:[UIColor grayColor]];
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
    
    if ([self.delegate respondsToSelector:@selector(evaluationTagSelectWithArray:)]) {
        [self.delegate evaluationTagSelectWithArray:self.selectTagsArray];
    }
}

@end
