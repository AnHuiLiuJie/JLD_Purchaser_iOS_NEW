//
//  PrescriptionPromptCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "PrescriptionPromptCell.h"

@interface PrescriptionPromptCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *promptLab;

@end

static CGFloat spacing = 10.0f;


@implementation PrescriptionPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self sertUpBase];
    }
    return self;
}

#pragma mark - base//H2=1+10+X+5+x+5
- (void)sertUpBase {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //CGFloat H2=1+10+20+5+20+5;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
        //make.height.equalTo(H2).priorityHigh();
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.width.equalTo(kScreenW-20-30);
        make.top.equalTo(self.bgView.top);
        make.height.equalTo(1);
    }];

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = @"请选择已确诊疾病";
    _titleLab.numberOfLines = 0;
    [_bgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(_lineView.top).offset(10);
    }];
    
    _subtitleLab = [[UILabel alloc] init];
    _subtitleLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _subtitleLab.font = [UIFont fontWithName:PFR size:14];
    _subtitleLab.textAlignment = NSTextAlignmentLeft;
    _subtitleLab.numberOfLines = 0;
    _subtitleLab.text = @"（必填,可多选）";
    [_bgView addSubview:_subtitleLab];
    [_subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.right).offset(0);
        make.bottom.equalTo(_titleLab.bottom).offset(0);
    }];
    
    _promptLab = [[UILabel alloc] init];
    _promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _promptLab.font = [UIFont fontWithName:PFR size:14];
    _promptLab.textAlignment = NSTextAlignmentLeft;
    _promptLab.numberOfLines = 0;
    _promptLab.text = @"(请您选择在线下确诊的相关疾病)";
    [_bgView addSubview:_promptLab];
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.left).offset(0);
        make.top.equalTo(_titleLab.bottom).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-5);
    }];
    
    //[self.bgView layoutIfNeeded];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
