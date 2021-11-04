//
//  PrescriptionConfirmCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "PrescriptionConfirmCell.h"

@interface PrescriptionConfirmCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *promptLab;

@property (nonatomic, strong) MASConstraint *viewBottomConstraint;
@property (nonatomic, strong) MASConstraint *viewBottomConstraint2;


@end

static CGFloat spacing = 10.0f;

@implementation PrescriptionConfirmCell

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

#pragma mark - set
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    _statusBtn.selected = YES;
    _promptLab.hidden = YES;
    [_viewBottomConstraint uninstall];
    [_viewBottomConstraint2 uninstall];
    [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
    }];
    
}

#pragma mark - base//H1=5+X+5+x+5 去掉一个x
- (void)sertUpBase {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //CGFloat H1=5+50+5+50+5;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
        //make.height.equalTo(H1).priorityHigh();
    }];
    
    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.selected = NO;
    [_statusBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:UIControlStateNormal];
    [_statusBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    [_bgView addSubview:_statusBtn];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.left).offset(5);
        make.top.equalTo(_bgView.top).offset(5);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_statusBtn addTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = @"确认已在实体医院就诊，且服用过订单中药品，无不良反应。";
    _titleLab.numberOfLines = 0;
    [_bgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusBtn.right).offset(5);
        make.top.equalTo(_statusBtn.top);
        //make.right.equalTo(self.bgView.right).offset(-10);
        make.width.equalTo(kScreenW-5-20-5-20-10);
    }];
    
    _promptLab = [[UILabel alloc] init];
    _promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _promptLab.font = [UIFont fontWithName:PFR size:14];
    _promptLab.textAlignment = NSTextAlignmentLeft;
    _promptLab.numberOfLines = 0;
    _promptLab.text = @"根据相关法律规定，用户购买处方药，需先在实体医院完成就诊。";
    [_bgView addSubview:_promptLab];
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.left);
        _viewBottomConstraint2 = make.top.equalTo(_titleLab.bottom).offset(5);
        make.width.equalTo(_titleLab.width);
        _viewBottomConstraint = make.bottom.equalTo(self.bgView.bottom).offset(-5);
    }];
    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _bgView.tag = 1;
    [_bgView addGestureRecognizer:tap3];
    
    //[self.bgView layoutIfNeeded];

}

- (void)statusAction:(id)sender{
    [self tapAction:nil];
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{//
    _statusBtn.selected = YES;
    _promptLab.hidden = YES;
    [_viewBottomConstraint uninstall];
    [_viewBottomConstraint2 uninstall];
    [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
    }];
    
//    CGFloat H1=5+40+5+5;
//    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(H1).priorityHigh();
//    }];
    
//    _statusBtn.selected = !_statusBtn.selected;
//    [_viewBottomConstraint uninstall];
//    [_viewBottomConstraint2 uninstall];
//    if (_statusBtn.selected) {
//        _promptLab.hidden = YES;
//        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            _viewBottomConstraint = make.bottom.equalTo(self.bgView.bottom).offset(-5);
//        }];
//    }else{
//        _promptLab.hidden = NO;
//        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            _viewBottomConstraint2 = make.bottom.equalTo(self.promptLab.bottom).offset(5);
//        }];
//
//        [_promptLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            _viewBottomConstraint = make.bottom.equalTo(self.bgView.bottom).offset(-5);
//        }];
//    }
    
    !_PrescriptionConfirmCell_block ? : _PrescriptionConfirmCell_block();

    
    [self.bgView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
