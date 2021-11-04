//
//  GLPHomeSpikeCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPHomeSpikeCell.h"

static int itemH = 145;

@interface GLPHomeSpikeCell ()
{
    int _scrollBgViewH;
    int _itemW;
    int _spacing;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topBgImg;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UIButton *seeBtn;

@property (nonatomic, strong) UIScrollView *scrollBgView;
@property (nonatomic, assign) BOOL isFirst;
@end

#pragma mark - Intial
@implementation GLPHomeSpikeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - initialize
- (void)setUpUI
{
    _spacing = 10;
    _itemW = floor((kScreenW-14*2-3*_spacing - 5*2)/3.5);
    _scrollBgViewH = itemH+5+5;

    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#FEF4F3"];
    [_bgView dc_cornerRadius:8];
    [self.contentView addSubview:_bgView];
    
    _topBgImg = [[UIImageView alloc] init];
    _topBgImg.contentMode = UIViewContentModeScaleToFill;
    [_bgView addSubview:_topBgImg];
    _topBgImg.userInteractionEnabled = YES;

    _iconImg = [[UIImageView alloc] init];
    _iconImg.image = [UIImage imageNamed:@"dc_home_clock"];
    [_topBgImg addSubview:_iconImg];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont fontWithName:PFRSemibold size:18];
    _titleLab.text = @"秒杀";
    [_topBgImg addSubview:_titleLab];
    
    _subtitleLab = [[UILabel alloc] init];
    _subtitleLab.textColor = [UIColor whiteColor];
    _subtitleLab.font = [UIFont fontWithName:PFR size:13];
    _subtitleLab.text = @"每天10点上新,限时限量";
    [_topBgImg addSubview:_subtitleLab];
    
    
    _seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _seeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    [_seeBtn setTitle:@"去看看" forState:0];
    [_seeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FD644C"] forState:0];
    _seeBtn.titleLabel.font = [UIFont fontWithName:PFR size:13];
    [_seeBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xhong"] forState:0];
    _seeBtn.adjustsImageWhenHighlighted = NO;
    [_seeBtn dc_cornerRadius:14];
    _seeBtn.bounds = CGRectMake(0, 0, 70, 28);
    [_seeBtn dc_buttonIconRightWithSpacing:5];
    [_seeBtn addTarget:self action:@selector(seeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topBgImg addSubview:_seeBtn];
    
    _scrollBgView = [[UIScrollView alloc] init];
    _scrollBgView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_scrollBgView];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 14, 0, 14));
    }];

    [_topBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.equalTo(47).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgImg.left).offset(12);
        make.centerY.equalTo(self.topBgImg.centerY);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImg.centerY);
        make.left.equalTo(self.iconImg.right).offset(8);
    }];
    
    [_subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.centerY);
        make.left.equalTo(self.titleLab.right).offset(10);
    }];
    
    [_seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImg.centerY);
        make.right.equalTo(self.topBgImg.right).offset(-12);
        make.size.equalTo(CGSizeMake(70, 28));
    }];
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgImg.bottom);
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(_scrollBgViewH).priorityHigh();
    }];
    
}

#pragma mark - Setter Getter Methods
-(void)setSpikeList:(NSArray<DCSeckillListModel *> *)spikeList{
    
    if ([spikeList isEqualToArray:_spikeList]) {
        _isFirst = YES;
    }else
        _isFirst = NO;

    _spikeList = spikeList;
    
    _topBgImg.image = [UIImage imageNamed:@"dc_home_spike"];
    
    //_subtitleLab.text = @"";
    
    if (_spikeList.count > 0 && !_isFirst) {
        for(UIView *view in [self.scrollBgView subviews]){
            if ([view isKindOfClass:[GLPHomeSpikeGoodsView class]]) {
                [view removeFromSuperview];
            }
        }
        _isFirst = YES;

        for (int i=0; i<_spikeList.count; i++) {
            DCSeckillListModel *model = _spikeList[i];
            GLPHomeSpikeGoodsView *view = [[GLPHomeSpikeGoodsView alloc] init];
            [self.scrollBgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollBgView.top).offset(5);
                make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
                make.width.equalTo(_itemW);
                make.height.equalTo(itemH);
            }];
            view.listModel = model;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            view.tag = i;
            [view addGestureRecognizer:tap3];
        }
        self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_spikeList.count, _scrollBgViewH);
    }
    
    [self layoutIfNeeded];
}

#pragma mark - private method
- (void)seeBtnClick:(UIButton *)button{
    !_GLPHomeSpikeCell_moreBlock ? : _GLPHomeSpikeCell_moreBlock();
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer{
    UIView *view = recognizer.view;
    DCSeckillListModel *model = _spikeList[view.tag];
    !_GLPHomeSpikeCell_clickGoodsBlock ? : _GLPHomeSpikeCell_clickGoodsBlock(model);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




#pragma mark  itme subView
@interface GLPHomeSpikeGoodsView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, assign) BOOL isFristLoad;

@end

@implementation GLPHomeSpikeGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    [_bgView dc_cornerRadius:5];

    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    _iconImage.clipsToBounds = YES;
    _iconImage.image = [UIImage imageNamed:@"img1"];
    [_bgView addSubview:_iconImage];
    self.iconImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont fontWithName:PFR size:11];
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF2800"];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"秒杀价¥0.00";
    _priceLabel.font = [UIFont fontWithName:PFRMedium size:13];
    [_bgView addSubview:_priceLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(itemH).priorityHigh();
    }];
    
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.bgView.top);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(self.bgView.width).multipliedBy(0.9);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.iconImage.bottom).offset(5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.bottom).offset(-2);
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
    }];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
}



#pragma mark - setter
- (void)setListModel:(DCSeckillListModel *)listModel
{
    _listModel = listModel;
    
    NSString *title = [NSString stringWithFormat:@"%@%@",_listModel.goodsName,@""];//_listModel.packingSpec
    _titleLabel.text = title;
    
    NSString *imageUrl = _listModel.goodsImg;
//    WEAKSELF;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
//        if (!weakSelf.isFristLoad) {
//            [weakSelf.iconImage setImage:[UIImage dc_scaleToImage:weakSelf.iconImage size:weakSelf.iconImage.bounds.size]];
//            //self.isFristLoad = YES;
//        }
    }];

    _priceLabel.text = [NSString stringWithFormat:@"秒杀价¥%@",_listModel.price];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:[UIFont fontWithName:PFR size:10] maxFont:[UIFont fontWithName:PFRMedium size:15] forReplace:@"秒杀价¥"];
}

@end
