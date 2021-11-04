//
//  EtpBillListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "EtpBillListCell.h"
#import "UILabel+Category.h"

@interface EtpBillListCell ()

@property (nonatomic, strong) UILabel *title_P;
@property (nonatomic, strong) UILabel *title_L;
@property (nonatomic, strong) UILabel *content_L;

@property (nonatomic, strong) UILabel *amount_L;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;

@end

@implementation EtpBillListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgView];
//    _bgView.layer.borderColor = [UIColor redColor].CGColor;
//    _bgView.layer.borderWidth = 1;
    
    _title_P = [[UILabel alloc] init];
    _title_P.text = @"订单编号:";
    _title_P.textColor = [UIColor dc_colorWithHexString:@"#555555"];
    _title_P.font = [UIFont fontWithName:PFR size:13];
    [_bgView addSubview:_title_P];
    _title_L = [[UILabel alloc] init];
    _title_L.text = @"******************";
    _title_L.textColor = [UIColor dc_colorWithHexString:@"#555555"];
    _title_L.font = [UIFont fontWithName:PFR size:15];
    [_bgView addSubview:_title_L];
    _content_L = [[UILabel alloc] init];
    _content_L.text = @"交易**";
    _content_L.textColor = [UIColor dc_colorWithHexString:@"#A3A3A3"];
    _content_L.font = [UIFont fontWithName:PFR size:12];
    [_bgView addSubview:_content_L];
    
    _amount_L = [[UILabel alloc] init];
    _amount_L.text = @"**.**";
    _amount_L.textColor = [UIColor dc_colorWithHexString:@"#FD4B14"];
    _amount_L.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_amount_L];


    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture.minimumPressDuration = 0.8f;//设置长按 时间
    _title_L.userInteractionEnabled = YES;
    [_title_L addGestureRecognizer:longPressGesture];
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_model.extendAmount.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _model.extendAmount;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - set model -
-(void)setModel:(EtpOrderPageListModel *)model{
    _model = model;
    _title_L.text = [NSString stringWithFormat:@"%@",_model.orderNo];
    _content_L.text = [NSString stringWithFormat:@"%@",model.orderStateStr];
    _amount_L.text =  [NSString stringWithFormat:@"¥%@",model.extendAmount];
    _amount_L = [UILabel setupAttributeLabel:_amount_L textColor:_amount_L.textColor minFont:[UIFont fontWithName:PFR size:12] maxFont:nil forReplace:@"¥"];
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [_title_P mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(15);
    }];
    
    [_title_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_P.right).offset(2);
        make.centerY.equalTo(self.title_P.centerY);
    }];
    
    [_content_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_P.left).offset(0);
        make.top.equalTo(self.title_P.bottom).offset(5);
    }];
    
    [_amount_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(self.bgView.right).offset(-8);
    }];
    
//    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView.left).offset(15);
//        make.right.equalTo(self.bgView.right);
//        make.bottom.equalTo(self.bgView.bottom);
//        make.height.equalTo(1);
//    }];
//
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
