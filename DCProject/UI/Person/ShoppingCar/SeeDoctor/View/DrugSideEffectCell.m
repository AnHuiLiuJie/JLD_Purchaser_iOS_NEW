//
//  DrugSideEffectCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "DrugSideEffectCell.h"
@interface DrugSideEffectCell (){
    CGFloat labelH;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *addBtn;

@end

static CGFloat spacing = 10.0f;


@implementation DrugSideEffectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        labelH = 30;
        [self sertUpBase];
    }
    return self;
}

#pragma mark - base//H3=
- (void)sertUpBase {
    
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
    }];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_bgView);
        make.height.equalTo(30);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFR size:15];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = @"[药品名称]";
    _titleLab.numberOfLines = 0;
    [_topView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.left).offset(10);
        make.centerY.equalTo(_topView.centerY);
    }];
    
    
    _addBtn = [[UIButton alloc] init];
    [_bgView addSubview:_addBtn];
    _addBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
    _addBtn.titleLabel.font = [UIFont fontWithName:PFR size:12];
    [_addBtn setTitle:@"添加疾病" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.bottom);
        make.right.equalTo(_bgView.right).offset(-8);
        make.size.equalTo(CGSizeMake(70, 25));
    }];
    [_addBtn dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:DC_BtnColor] radius:5];

    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.bottom);
        make.bottom.left.equalTo(_bgView);
        make.right.equalTo(_addBtn.left);
        make.height.mas_greaterThanOrEqualTo(45).priorityHigh();
    }];
    
}

#pragma mark - add
- (void)addBtnAction:(UIButton *)btn{
    !_DrugSideEffectCell_block ? : _DrugSideEffectCell_block();
}

#pragma mark - set
- (void)setSelctedSymptom:(NSMutableArray *)selctedSymptom{
    _selctedSymptom = selctedSymptom;
    
    [_selctedSymptom enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self.bottomView viewWithTag:1001];
        for (UIView *btn in view.subviews) {
            NSString *title = [NSString stringWithFormat:@"  %@  ",str];
            if ([title isEqualToString:((UIButton *)btn).titleLabel.text]) {
                ((UIButton *)btn).selected = YES;
                ((UIButton *)btn).backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
                [DCSpeedy dc_changeControlCircularWith:((UIButton *)btn) AndSetCornerRadius:labelH/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
            }
        }
    }];

}

-(void)setModel:(MedicalSymptomListModel *)model{
    _model = model;
    
    //_titleLab.text = [NSString stringWithFormat:@"[%@]",_model.goodsName];
    _titleLab.text = [NSString stringWithFormat:@"[%@]",_model.goodsTitle];
    [self create_typeLabelOnView:_model.symptom];

}

- (void)create_typeLabelOnView:(NSArray *)array
{
    UIView *view = [[UIView alloc] init];
    [[self.bottomView viewWithTag:1001] removeFromSuperview];
    [self.bottomView addSubview:view];

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView).insets(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    
    CGFloat viewW = kScreenW -spacing*2-8-70-20;
    view.tag = 1001;
    CGFloat ALLW = 0;
    CGFloat index_w = 0;
    CGFloat newRow = 0;
    for (NSString *str in array) {
        NSString *title = [NSString stringWithFormat:@"  %@  ",str];
        UIFont *font = [UIFont fontWithName:PFR size:14];
        CGFloat labelW = [DCSpeedy getWidthWithText:title height:labelH font:font];
        index_w = index_w+labelW+6;
        if (index_w > viewW) {
            newRow++;
            ALLW = 0;
            index_w = 0;
        }
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.backgroundColor = [UIColor whiteColor];
        subBtn.titleLabel.font = font;
        [subBtn setTitle:title forState:UIControlStateNormal];
        [subBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ACACAC"] forState:UIControlStateNormal];
        [subBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];

        [subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:subBtn];
        
        CGFloat y = (8+labelH)*newRow;
        [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(ALLW);
            make.top.equalTo(view).offset(y);
            make.size.equalTo(CGSizeMake(labelW, labelH));
        }];
        ALLW = ALLW+labelW+6;
        [DCSpeedy dc_changeControlCircularWith:subBtn AndSetCornerRadius:labelH/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#ACACAC"] canMasksToBounds:YES];
    }
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(45+(8+labelH)*newRow).priorityHigh();
    }];
    
}

- (void)subBtnAction:(UIButton *)button{
    NSArray *arr = [self getSelectedType];
    if (arr.count > 1) {
        //[DC_KEYWINDOW makeToast:@"每个药品最多提交2个症状" duration:2 position:CSToastPositionBottom];
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_changeControlCircularWith:button AndSetCornerRadius:button.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#ACACAC"] canMasksToBounds:YES];
        NSArray *arr = [self getSelectedType];
        if (arr.count > 1) {
            [DC_KEYWINDOW makeToast:@"每个药品最多提交2个症状" duration:2 position:CSToastPositionBottom];
        }
        return;
    }
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
        [DCSpeedy dc_changeControlCircularWith:button AndSetCornerRadius:button.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
    }else{
        button.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_changeControlCircularWith:button AndSetCornerRadius:button.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#ACACAC"] canMasksToBounds:YES];
    }
    
    NSArray *arr2 = [self getSelectedType];
    
    __block NSString *symptoms = @"";
    [arr2 enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            symptoms = str;
        }else{
            symptoms = [NSString stringWithFormat:@"%@,%@",symptoms,str];
        }
    }];
    !_DrugSideEffectCell_backBlock ? : _DrugSideEffectCell_backBlock(symptoms);
    
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
//    [paramDic setObject:symptom forKey:self.model.goodsId];
//
//    !_DrugSideEffectCell_backBlock ? : _DrugSideEffectCell_backBlock(paramDic);
}

- (NSArray *)getSelectedType{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UIView *view = [self.bottomView viewWithTag:1001];
    for (UIView *btn in view.subviews) {
        BOOL isSelected = ((UIButton *)btn).selected;
        if (isSelected) {
            NSString *text = ((UIButton *)btn).titleLabel.text;
            NSString *str1 = [text substringFromIndex:2];
            NSString *str2 = [str1 substringToIndex:str1.length-2];//把多余的空格去掉
            [arr addObject:str2];
        }
    }
    
    return arr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
