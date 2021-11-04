//
//  LogisticsInfoListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "LogisticsInfoListCell.h"

@implementation LogisticsInfoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self setViewUI];
}

- (void)setViewUI{
    
    _itemW = 74;
    _itemH = _itemW + 20 + 20 + 5;
    _spacing = (kScreenW - _itemW*4 - 5*2 - 30)/3;
    
    self.topBgView.backgroundColor = [UIColor whiteColor];
    self.bottomBgView.backgroundColor = [UIColor whiteColor];
    [_replicateBtn addTarget:self action:@selector(copyNoAction) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollBgView = [[UIScrollView alloc] init];
    [self.bottomBgView addSubview:_scrollBgView];
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBgView.left).offset(5);
        make.top.equalTo(self.bottomBgView.top);
        make.right.equalTo(self.bottomBgView.right).offset(-35);
        make.bottom.equalTo(self.bottomBgView.bottom);
        make.height.equalTo(_itemH);
    }];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction3:)];
    [_scrollBgView addGestureRecognizer:tap3];

    
    [self layoutSubviews];
}

#pragma mark - action
- (void)tapAction3:(UITapGestureRecognizer *)recognizer
{
    !_LogisticsInfoListCell_Block ? : _LogisticsInfoListCell_Block();
}

- (void)copyNoAction{
    if (self.model.logisticsNo  == nil) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.model.logisticsNo];
    [SVProgressHUD showSuccessWithStatus:@"复制成功！"];
}

#pragma mark - set
- (void)setModel:(DeliveryListModel *)model{
    _model = model;
    
    if (_model.logisticsNo.length != 0) {
        _titleLab.text = @"配送信息";
        _logisticsFirmName.text = _model.logisticsFirmName;
        _logisticsNo.text = [NSString stringWithFormat:@"单号：%@",_model.logisticsNo];
        _logisticsFirmName.hidden = NO;
        _logisticsNo.hidden = NO;
        _replicateBtn.hidden = NO;
        _arrowImg.hidden = NO;
    }else{
        _titleLab.text = @"\n待发货";
        _logisticsFirmName.hidden = YES;
        _logisticsNo.hidden = YES;
        _replicateBtn.hidden = YES;
        _arrowImg.hidden = YES;
    }
    
    NSArray *listArray = _model.orderGoodsList;
    
    if (listArray.count > 0) {
        for (int i=0; i<listArray.count; i++) {
            GLPOrderGoodsListModel *similarModel = listArray[i];
            LogisticsInfoGoodsListView *view = [[LogisticsInfoGoodsListView alloc] init];
            [self.scrollBgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
                make.centerY.equalTo(self.scrollBgView.centerY);
                make.height.equalTo(_itemH);
                make.width.equalTo(_itemW);
            }];
            view.model = similarModel;
            view.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//            view.tag = i;
//            [view addGestureRecognizer:tap3];
        }
    }
    self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*listArray.count, _itemH);
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView * view = recognizer.view;
    if ( _model.orderGoodsList.count > 0) {
        if (_LogisticsInfoListCell_block) {
            _LogisticsInfoListCell_block(_model.orderGoodsList[view.tag]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma mark - 商品
@interface LogisticsInfoGoodsListView ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation LogisticsInfoGoodsListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF2800"];
    _priceLabel.font = PFRFont(14);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"¥0.00";
    [self addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.height.equalTo(self.width).multipliedBy(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.goodsImage.bottom).offset(3);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.titleLabel.bottom).offset(3);
    }];
}


#pragma mark - setter
- (void)setModel:(GLPOrderGoodsListModel *)model{
    _model = model;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _model.goodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.sellPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
}

@end
