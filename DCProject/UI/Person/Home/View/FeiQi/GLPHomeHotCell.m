//
//  GLPHomeHotCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeHotCell.h"

@interface GLPHomeHotCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UIView *goodsBgView;

@property (nonatomic, strong) GLPHomeHotGoodsView *goodView1;
@property (nonatomic, strong) GLPHomeHotGoodsView *goodView2;
@property (nonatomic, strong) GLPHomeHotGoodsView *goodView3;
@property (nonatomic, strong) GLPHomeHotGoodsView *goodView4;

@end

@implementation GLPHomeHotCell

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:8];
    [self.contentView addSubview:_bgView];
    
    _headImage = [[UIImageView alloc] init];
    _headImage.image = [UIImage imageNamed:@"rx"];
    [self.contentView addSubview:_headImage];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dc_home_rexiao"];
    [_headImage addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.text = @"";
    [_headImage addSubview:_titleLabel];
    
    _seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _seeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    [_seeBtn setTitle:@"去看看" forState:0];
    [_seeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#F9B64B"] forState:0];
    _seeBtn.titleLabel.font = [UIFont fontWithName:PFR size:13];
    [_seeBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xhong"] forState:0];
    _seeBtn.adjustsImageWhenHighlighted = NO;
    [_seeBtn dc_cornerRadius:14];
    _seeBtn.bounds = CGRectMake(0, 0, 70, 28);
    [_seeBtn dc_buttonIconRightWithSpacing:5];
    [_seeBtn addTarget:self action:@selector(seeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headImage addSubview:_seeBtn];
    _headImage.userInteractionEnabled = YES;
    
    _goodsBgView = [[UIView alloc] init];
    _goodsBgView.backgroundColor = [UIColor whiteColor];
    [_goodsBgView dc_cornerRadius:10];
    [self.contentView addSubview:_goodsBgView];

    _goodView1 = [[GLPHomeHotGoodsView alloc] init];
    _goodView1.tag=100;
    _goodView1.userInteractionEnabled = YES;
    [_goodsBgView addSubview:_goodView1];
    
    _goodView2 = [[GLPHomeHotGoodsView alloc] init];
    _goodView2.tag=101;
    _goodView2.userInteractionEnabled = YES;
    [_goodsBgView addSubview:_goodView2];
    
    _goodView3 = [[GLPHomeHotGoodsView alloc] init];
    _goodView3.tag=102;
    _goodView3.userInteractionEnabled = YES;
    [_goodsBgView addSubview:_goodView3];
    
    _goodView4 = [[GLPHomeHotGoodsView alloc] init];
    _goodView4.tag=103;
    _goodView4.userInteractionEnabled = YES;
    [_goodsBgView addSubview:_goodView4];
    
   
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodViewClick:)];
    [_goodView1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodViewClick:)];
    [_goodView2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodViewClick:)];
    [_goodView3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodViewClick:)];
    [_goodView4 addGestureRecognizer:tap4];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)seeBtnClick:(UIButton *)button
{
    if (self.hotseeBlock) {
        self.hotseeBlock();
    }
}

- (void)goodViewClick:(UITapGestureRecognizer *)sender
{
    GLPHomeHotGoodsView *goodsView = (GLPHomeHotGoodsView *)sender.view;
    if (self.hotgoodsBlock) {
        self.hotgoodsBlock(_hotModel.dataList[goodsView.tag - 100]);
    }
}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacing = (kScreenW - 14*2 - 10*2 - 74*4)/3;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 14, 0, 14));
    }];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top);
        make.height.equalTo(45);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(12);
        make.centerY.equalTo(self.headImage.centerY);
        make.size.equalTo(CGSizeMake(16, 19));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.iconImage.right).offset(10);
    }];
    
    [_seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.right.equalTo(self.headImage.right).offset(-12);
        make.size.equalTo(CGSizeMake(70, 28));
    }];
    
    [_goodsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.headImage.bottom).offset(0);
//        make.bottom.equalTo(self.bgView.bottom).offset(-12);//lj_change_约束
        make.height.equalTo(130);
    }];
    
    [_goodView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBgView.left);
        make.top.equalTo(self.goodsBgView.top).offset(10);
        make.bottom.equalTo(self.goodsBgView.bottom).offset(-3);
        make.width.equalTo(74);
    }];
    
    [_goodView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodView1.right).offset(spacing);
        make.top.equalTo(self.goodView1.top);
        make.bottom.equalTo(self.goodView1.bottom);
        make.width.equalTo(self.goodView1.width);
    }];
    
    [_goodView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodView2.right).offset(spacing);
        make.top.equalTo(self.goodView1.top);
        make.bottom.equalTo(self.goodView1.bottom);
        make.width.equalTo(self.goodView2.width);
    }];
    
    [_goodView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodView3.right).offset(spacing);
        make.top.equalTo(self.goodView1.top);
        make.bottom.equalTo(self.goodView1.bottom);
        make.width.equalTo(self.goodView3.width);
    }];
}


#pragma mark - setter
- (void)setHotModel:(GLPHomeDataModel *)hotModel
{
    _hotModel = hotModel;
    
    _titleLabel.text = _hotModel.spaceName;
    
    _goodView1.hidden = YES;
    _goodView2.hidden = YES;
    _goodView3.hidden = YES;
    _goodView4.hidden = YES;
    if (_hotModel.dataList && _hotModel.dataList.count > 0) {
        for (int i=0; i<_hotModel.dataList.count; i++) {
            GLPHomeDataListModel *listModel = _hotModel.dataList[i];
            if ( i==0 ) {
                
                _goodView1.hidden = NO;
                _goodView1.listModel = listModel;
                
            } else if (i == 1) {
                
                _goodView2.hidden = NO;
                _goodView2.listModel = listModel;
                
            } else if (i == 2) {
                
                _goodView3.hidden = NO;
                _goodView3.listModel = listModel;
                
            }else if (i == 3) {
                
                _goodView4.hidden = NO;
                _goodView4.listModel = listModel;
            }
        }
    }
}

@end




#pragma mark - 季节用药 商品
@interface GLPHomeHotGoodsView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, assign) BOOL isFristLoad;

@end

@implementation GLPHomeHotGoodsView

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    _iconImage.clipsToBounds = YES;
    _iconImage.image = [UIImage imageNamed:@"img1"];
    [self addSubview:_iconImage];
    self.iconImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF2800"];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"¥0.00";
    _priceLabel.font = [UIFont fontWithName:PFRMedium size:13];
    [self addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
        make.right.equalTo(self.right);
        make.height.equalTo(self.width).multipliedBy(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.iconImage.bottom).offset(3);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
    }];
    
    [_priceLabel dc_cornerRadius:_priceLabel.dc_height/2];
}



#pragma mark - setter
- (void)setListModel:(GLPHomeDataListModel *)listModel
{
    _listModel = listModel;
    
    NSString *title = @"";
    if (_listModel.subTitle && _listModel.subTitle.length > 0) {
        title = _listModel.subTitle;
    }
    if (title.length == 0) {
        title = _listModel.infoTitle;
    }
    
    _titleLabel.text = title;
    
    NSString *imageUrl = _listModel.imgUrl;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
//        if (!self.isFristLoad) {
//            [self.iconImage setImage:[UIImage dc_scaleToImage:self.iconImage size:self.iconImage.bounds.size]];
//            //self.isFristLoad = YES;
//        }
    }];


    GLPHomeDataGoodsModel *goodsModel = _listModel.goodsVo;
    if (goodsModel && goodsModel.goodsPrice) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.goodsPrice];
        _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFR size:14] forReplace:@"¥"];
    }
    
}


@end
