//
//  EtpWithdrawTwoCell.m
//  DCProject
//
//  Created by LiuMac on 2021/5/25.
//

#import "EtpWithdrawTwoCell.h"
#import "UILabel+Category.h"

@interface EtpWithdrawTwoCell ()


@property (nonatomic, strong) UILabel *title_L;
@property (nonatomic, strong) UILabel *content_L;

@property (nonatomic, strong) UILabel *amount_L;

@property (nonatomic, strong) UIImageView *arrow_Img;

@end

@implementation EtpWithdrawTwoCell

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
    
    _title_L = [[UILabel alloc] init];
    _title_L.text = @"*月份对账单";
    _title_L.textColor = [UIColor dc_colorWithHexString:@"#555555"];
    _title_L.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_title_L];
    _content_L = [[UILabel alloc] init];
    _content_L.text = @"您的*月份业绩已出，请查收";
    _content_L.textColor = [UIColor dc_colorWithHexString:@"#A3A3A3"];
    _content_L.font = [UIFont fontWithName:PFR size:12];
    [_bgView addSubview:_content_L];
    
    _amount_L = [[UILabel alloc] init];
    _amount_L.text = @"**.**";
    _amount_L.textColor = [UIColor dc_colorWithHexString:@"#FD4B14"];
    _amount_L.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_amount_L];
    
    _arrow_Img = [[UIImageView alloc] init];
    [_arrow_Img setImage:[UIImage imageNamed:@"dc_arrow_right_xh"]];
    [_bgView addSubview:_arrow_Img];

    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#E7E7E7"];
    [_bgView addSubview:_line];
}

#pragma mark - set model -
-(void)setModel:(EtpBillListModel *)model{
    _model = model;
    NSString *month = [NSString getFirstNoZoneStr:model.billMonth];
    _title_L.text = [NSString stringWithFormat:@"%@份对账单",month];
    _content_L.text = [NSString stringWithFormat:@"您的%@份业绩已出，请查收",month];

    _amount_L.text =  [NSString stringWithFormat:@"¥%@",model.incomeAmount];
    _amount_L = [UILabel setupAttributeLabel:_amount_L textColor:_amount_L.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    
}

-(void)setIndex_row:(BOOL)index_row{
    _index_row = index_row;
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    [_title_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(15);
    }];
    
    [_content_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_L.left).offset(0);
        make.top.equalTo(self.title_L.bottom).offset(5);
    }];
    
    [_arrow_Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(self.bgView.right).offset(-8);
        make.size.equalTo(CGSizeMake(6, 12));
    }];
    
    [_amount_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow_Img.left).offset(-10);
        make.centerY.equalTo(_arrow_Img);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(1);
    }];
    
    if (_index_row) {
//        [_bgView dc_cornerRadius:10 rectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(10, 1)];

        _line.hidden = YES;
    }else
        _line.hidden = NO;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
