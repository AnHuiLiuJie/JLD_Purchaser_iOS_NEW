//
//  GLPGoodsDetailsDiscountCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/2.
//

#import "GLPGoodsDetailsDiscountCell.h"

@interface GLPGoodsDetailsDiscountCell ()
{
    CGFloat _itemW;
    CGFloat _spacing;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIScrollView *scrollBgView;
@property (nonatomic, strong) UIButton *moreBtn;

@end

static CGFloat cell_spacing_x = 10;
static CGFloat cell_spacing_y = 5;
static CGFloat cell_spacing_h = 40;

@implementation GLPGoodsDetailsDiscountCell
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
    
    _itemW = 74;
    _spacing = (kScreenW - _itemW*3 - cell_spacing_x*2 - 50 - 60)/2;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    //_bgView.bounds = CGRectMake(0, 0, kScreenW-cell_spacing_x*2, cell_spacing_h);
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLab.text = @"优惠";
    [_bgView addSubview:_titleLab];
    
    _scrollBgView = [[UIScrollView alloc] init];
    [_bgView addSubview:_scrollBgView];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"dc_cell_more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_moreBtn];
}

#pragma mark - Setter Getter Methods
- (void)setListArray:(NSMutableArray *)listArray{
    _listArray = listArray;
    if (self.scrollBgView.subviews.count > 0) {
        return;
    }
    CGFloat itemH = cell_spacing_h-15;
    for (int i=0; i<_listArray.count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBgView addSubview:itemBtn];
        [itemBtn setTitle:_listArray[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FF3B30"] forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont fontWithName:PFR size:11];
        //[itemBtn setBackgroundImage:[[UIImage imageNamed:@"ycj_yh"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 0, 2)] forState:UIControlStateNormal];]
        [itemBtn setBackgroundImage:[UIImage imageNamed:@"ycj_yh"] forState:UIControlStateNormal];
        itemBtn.enabled = NO;
        itemBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
            make.centerY.equalTo(self.scrollBgView.centerY);
            make.height.equalTo(itemH);
            make.width.equalTo(_itemW);
        }];
    }
    
    self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_listArray.count, itemH);

    [self layoutSubviews];
}

#pragma mark - action
- (void)moreAction:(UIButton *)button{
    !_GLPGoodsDetailsDiscountCell_block ? : _GLPGoodsDetailsDiscountCell_block();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.centerY.equalTo(self.bgView.centerY);
    }];
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.right).offset(5);
        make.top.equalTo(self.bgView.top);
        make.right.equalTo(self.moreBtn.left);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-5);
        make.centerY.equalTo(self.bgView.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
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
