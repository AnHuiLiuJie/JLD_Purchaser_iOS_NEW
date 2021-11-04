//
//  GLPGoodsDetailsSpecificationsCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/22.
//

#import "GLPGoodsDetailsSpecificationsCell.h"

static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat cell_spacing_h = 80;

@interface GLPGoodsDetailsSpecificationsCell ()//prompt

/*背景View*/
@property (nonatomic, strong) UIView *bgView;
/*规格*/
@property (nonatomic,strong) UILabel *specificPrompt;
@property (nonatomic,strong) UILabel *specificLab;
@property (nonatomic, strong) UIView *specificView;
/*运费*/
@property (nonatomic,strong) UILabel *freightPrompt;
@property (nonatomic,strong) UILabel *freightLab;
/*配送*/
@property (nonatomic,strong) UILabel *deliveryPrompt;
@property (nonatomic,strong) UILabel *deliveryLab;

@property (nonatomic, strong) UIView *lineView;
/*右侧更多*/
@property (nonatomic, strong) UIButton *moreBtn;


@end

@implementation GLPGoodsDetailsSpecificationsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //[_bgView dc_cornerRadius:cell_spacing_x];
    
    _specificView = [[UIView alloc] init];
    _specificView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_specificView];
    
    self.specificPrompt = [[UILabel alloc] init];
    self.specificPrompt.text = @"规格";
    self.specificPrompt.font = [UIFont systemFontOfSize:15];
    self.specificPrompt.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    [_specificView addSubview:self.specificPrompt];
    
    self.specificLab = [[UILabel alloc] init];
    self.specificLab.text = @"请选择商品规格分类";
    self.specificLab.font = [UIFont systemFontOfSize:12];
    _specificLab.textAlignment = NSTextAlignmentLeft;
    self.specificLab.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    [_specificView addSubview:self.specificLab];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];//
    [_moreBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:UIControlStateNormal];//dc_cell_more
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_specificView addSubview:_moreBtn];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_specificView addGestureRecognizer:tap3];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_lineView];
    
    self.freightPrompt = [[UILabel alloc] init];
    self.freightPrompt.text = @"运费";
    self.freightPrompt.font = [UIFont systemFontOfSize:15];
    self.freightPrompt.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    [_bgView addSubview:self.freightPrompt];
    
    self.freightLab = [[UILabel alloc] init];
    self.freightLab.text = @"*.**";
    self.freightLab.font = [UIFont systemFontOfSize:12];
    self.freightLab.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    [_bgView addSubview:self.freightLab];
    
    self.deliveryPrompt = [[UILabel alloc] init];
    self.deliveryPrompt.text = @"配送";
    self.deliveryPrompt.font = [UIFont systemFontOfSize:15];
    self.deliveryPrompt.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    [_bgView addSubview:self.deliveryPrompt];
    
    self.deliveryLab = [[UILabel alloc] init];
    self.deliveryLab.text = @"24小时内发货";
    self.deliveryLab.font = [UIFont systemFontOfSize:12];
    self.deliveryLab.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    [_bgView addSubview:self.deliveryLab];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
        make.height.equalTo(1);
    }];
    
    [self.specificView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgView);
        make.bottom.equalTo(self.lineView.top);
    }];
    
    [self.specificPrompt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specificView.left).offset(15);
        make.centerY.equalTo(self.specificView.centerY);
    }];
    
    [self.specificLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specificPrompt.right).offset(5);
        make.centerY.equalTo(self.specificView.centerY);
        make.width.equalTo(kScreenW-130);
    }];
    
    [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.specificView).offset(-5);
        make.centerY.equalTo(self.specificView);

    }];
    
    [self.freightPrompt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.lineView);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [self.freightLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.freightPrompt.right).offset(5);
        make.centerY.equalTo(self.freightPrompt.centerY);
    }];
    
    //make.height.mas_equalTo(topView.mas_height).multipliedBy(0.5);
    [self.deliveryPrompt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX).offset(10);
        make.top.equalTo(self.lineView);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [self.deliveryLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deliveryPrompt.right).offset(5);
        make.centerY.equalTo(self.freightPrompt.centerY);
    }];
}

#pragma mark - set
- (void)setSpecificationsStr:(NSString *)specificationsStr{
    _specificationsStr = specificationsStr;
    if (specificationsStr.length > 0 && ![specificationsStr isEqualToString:@"请选择规格"]) {
        self.specificPrompt.text = @"已选规格";
        self.specificLab.text = specificationsStr;
        self.specificLab.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
        self.specificLab.font = [UIFont systemFontOfSize:12];
    }else{
        self.specificPrompt.text = @"请选规格";
        self.specificLab.text = @"请选择商品规格分类";
        self.specificLab.textColor = [UIColor dc_colorWithHexString:@"#8E8E8E"];
        self.specificLab.font = [UIFont systemFontOfSize:15];
    }
}

- (void)setAddressModel:(GLPGoodsAddressModel *)addressModel{
    _addressModel = addressModel;
    
    NSString *address = _addressModel.areaName;
    if (_addressModel.areaId.length==0 || address.length==0) {
        address = @"--";
    }else{
        GLPGoodsAddressExpressModel *model = [_addressModel.expressList firstObject];//详情页只有一个商品
        address = model.freight;
    }
    
    _freightLab.text = [NSString stringWithFormat:@"%@",address];
    
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    if (_detailModel.deliveryTime.length != 0) {
        _deliveryLab.text = _detailModel.deliveryTime;
    }
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer{
    //IView * view = recognizer.view;
    !_GLPGoodsDetailsSpecificationsCell_block ? : _GLPGoodsDetailsSpecificationsCell_block();
}

- (void)moreAction:(UIButton *)button{
    !_GLPGoodsDetailsSpecificationsCell_block ? : _GLPGoodsDetailsSpecificationsCell_block();
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
