//
//  GLPInvalidGoodsListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/15.
//

#import "GLPInvalidGoodsListCell.h"

#import "GLPInvalidGoodsCell.h"

static NSString *const GLPInvalidGoodsCellID = @"GLPInvalidGoodsCell";

#define kRowHeight 120

@interface GLPInvalidGoodsListCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *line;


@end

@implementation GLPInvalidGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _shopNameLabel.text = @"失效商品X件";
    [self.contentView addSubview:_shopNameLabel];
    
    _ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ticketBtn.adjustsImageWhenHighlighted = NO;
    [_ticketBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
    _ticketBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    [_ticketBtn setTitle:@"清空失效商品" forState:UIControlStateNormal];
    [_ticketBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _ticketBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:_ticketBtn];
    
    _line = [[UIImageView alloc] init];
    //_line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.rowHeight = kRowHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(GLPInvalidGoodsCellID) forCellReuseIdentifier:GLPInvalidGoodsCellID];
    [self.contentView addSubview:_tableView];
    [_tableView dc_layerBorderWith:1 color:[UIColor greenColor] radius:1];
    
    [self layoutIfNeeded];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPInvalidGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPInvalidGoodsCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 清空失效商品
- (void)ticketBtnClick:(UIButton *)button{
    !_GLPInvalidGoodsListCell_Block ? : _GLPInvalidGoodsListCell_Block();
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    //[super layoutSubviews];
    

    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView);
        make.height.equalTo(50).priorityHigh();
    }];

    
    [_ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.shopNameLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 30));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.shopNameLabel.bottom).offset(0);
        make.height.equalTo(1);
    }];
    
    CGFloat height = (self.dataArray.count*kRowHeight);
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line.bottom).offset(0);
        make.height.equalTo(height).priorityHigh();
        make.bottom.equalTo(self.contentView.bottom).offset(0);
    }];
}

#pragma mark - setter
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    _shopNameLabel.attributedText = [self attributeWithCount:[NSString stringWithFormat:@"%ld",dataArray.count]];
    
    [self.tableView reloadData];
    [self layoutSubviews];
}

#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithCount:(NSString *)money
{
    NSString *text = [NSString stringWithFormat:@"失效商品%@件",money];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 4)];

    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:20],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(4, money.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(text.length-1, 1)];
    
    return attrStr;
}


@end
