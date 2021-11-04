//
//  MedicalTreatmentMethodCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "MedicalTreatmentMethodCell.h"
@interface MedicalTreatmentMethodCell ()<UIScrollViewDelegate>
/* 上一次选中的按钮 */
@property (strong , nonatomic) UIButton *selectBtn;
/* indicatorView */
@property (strong , nonatomic) UIView *indicatorView;
/* titleView */
@property (strong , nonatomic) UIView *titleView;
/* scrollBgView */
@property (strong , nonatomic) UIScrollView *scrollBgView;

@property (assign , nonatomic) CGFloat itemH;
@property (assign , nonatomic) CGFloat itemW;
@property (assign , nonatomic) BOOL isFirstLoad;

@end

static CGFloat spacing = 10.0f;
@implementation MedicalTreatmentMethodCell

#pragma mark - LazyLoad
- (UIScrollView *)scrollBgView
{
    if (!_scrollBgView) {
        _scrollBgView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollBgView.showsVerticalScrollIndicator = NO;
        _scrollBgView.showsHorizontalScrollIndicator = NO;
        _scrollBgView.pagingEnabled = YES;
        _scrollBgView.bounces = NO;
        _scrollBgView.delegate = self;
    }
    return _scrollBgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _itemW = kScreenW - 2*spacing;
        
        [self sertUpBase];
        
        [self setUpTiTleView];
    }
    return self;
}

#pragma mark - set
-(void)setOnlineStatus:(NSString *)onlineStatus{
    _onlineStatus = onlineStatus;
    
    if (![onlineStatus isEqualToString:@"0"]) {
        UIButton *button = _titleView.subviews[1];
        button.selected = !button.selected;
        [_selectBtn setTitleColor:[UIColor dc_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    }
}

#pragma mark - base
- (void)sertUpBase {
    self.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
//    self.automaticallyAdjustsScrollViewInsets = false;
}

#pragma mark - 复诊开方
- (void)setUpTiTleView
{
    CGFloat titileH = 45;
    _titleView = [UIView new];
    _titleView.frame = CGRectMake(10, 0, _itemW, titileH);
    _titleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleView];
    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_titleView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(10, _titleView.dc_height/2)];

    NSArray *titleArray = @[@"复诊开方",@"上传处方"];
    CGFloat buttonX = 15;
    CGFloat buttonY = 3;
    CGFloat buttonW = (kScreenW - buttonX*2) / 2;
    CGFloat buttonH = titileH - buttonY;
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
        button.tag = i;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.frame = CGRectMake((i * buttonW) + buttonX, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:button];
    }
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, _titleView.dc_bottom - _indicatorView.dc_height, _itemW, 2);
    line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_titleView addSubview:line];
    
    UIButton *firstButton = _titleView.subviews[0];
    [self buttonClick:firstButton];
    
    _indicatorView = [UIView new];
    _indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    [firstButton.titleLabel sizeToFit];
    
    _indicatorView.dc_height = 2;
    _indicatorView.dc_width = firstButton.titleLabel.dc_width/2;
    _indicatorView.dc_centerX = firstButton.dc_centerX;
    _indicatorView.dc_y = _titleView.dc_bottom - _indicatorView.dc_height;
    [_titleView addSubview:_indicatorView];
    
    //self.scrollBgView.contentSize = CGSizeMake(_itemW * titleArray.count, 0);
}


#pragma mark - 按钮点击
- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:[UIColor dc_colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width/2;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
    CGPoint offset = _scrollBgView.contentOffset;
    offset.x = _scrollBgView.dc_width * button.tag;
    [_scrollBgView setContentOffset:offset animated:YES];
    
    NSString *onlineStatus = @"0";
    if (button.tag == 0) {
        onlineStatus = @"0";
    }else
        onlineStatus = @"1";
    !_MedicalTreatmentMethodCell_block ? : _MedicalTreatmentMethodCell_block(onlineStatus);
}

#pragma mark - 内容
- (void)setUpContentView
{
    
    self.scrollBgView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_scrollBgView];
    _scrollBgView.backgroundColor = [UIColor whiteColor];

    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView.top).offset(_titleView.dc_bottom+2);
        make.height.equalTo(_itemH);
        make.width.equalTo(_itemW);
        make.bottom.equalTo(self.contentView.bottom).offset(0);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger index = scrollView.contentOffset.x / scrollView.dc_width;
//    UIButton *button = _titleView.subviews[index];
    //[self buttonClick:button];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentView endEditing:YES];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
