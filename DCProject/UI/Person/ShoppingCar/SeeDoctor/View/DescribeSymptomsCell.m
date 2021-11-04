//
//  DescribeSymptomsCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "DescribeSymptomsCell.h"
#import "UITextView+placeholder.h"


@interface DescribeSymptomsCell ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;
@property (strong, nonatomic) UILabel *infoNumLab;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;


@end

static CGFloat spacing = 10.0f;


@implementation DescribeSymptomsCell

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

#pragma mark - base//H4=1+10+X+10+80+10
- (void)sertUpBase {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //CGFloat H4=1+10+20+10+80+10;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
        //make.height.equalTo(H4).priorityHigh();
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
    _titleLab.text = @"请您描述疾病症状";
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
    _subtitleLab.text = @"（选填）";
    [_bgView addSubview:_subtitleLab];
    [_subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.right).offset(0);
        make.bottom.equalTo(_titleLab.bottom).offset(0);
    }];
    
    //编辑内容
    _historyTextView = [[UITextView alloc] init];
    _historyTextView.delegate = self;
    _historyTextView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _historyTextView.font = [UIFont systemFontOfSize:14];
    _historyTextView.placeholder = @" 请输入过往病史";
    [_bgView addSubview:_historyTextView];
    [_historyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.titleLab.bottom).offset(10);
        make.height.equalTo(80);
        make.width.equalTo(kScreenW-20-30);
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
    }];
    [DCSpeedy dc_changeControlCircularWith:self.historyTextView AndSetCornerRadius:8 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];

    
    _infoNumLab = [[UILabel alloc] init];
    _infoNumLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _infoNumLab.font = [UIFont fontWithName:PFR size:14];
    _infoNumLab.textAlignment = NSTextAlignmentLeft;
    _infoNumLab.numberOfLines = 0;
    _infoNumLab.text = @"  0/200";
    [_bgView addSubview:_infoNumLab];
    [_infoNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_historyTextView.right).offset(-10);
        make.top.equalTo(_historyTextView.bottom).offset(-25);
    }];
    
    //[self.bgView layoutIfNeeded];

}
#pragma mark - set
-(void)setLeaveMsg:(NSString *)leaveMsg{
    _leaveMsg = leaveMsg;
    _historyTextView.text = _leaveMsg;
    _historyTextView.placeholder = @"";
    _infoNumLab.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)_leaveMsg.length];

}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 200) {
        ((UITextView *)textView).text = [((UITextView *)textView).text substringToIndex:200];
        [SVProgressHUD showInfoWithStatus:@"请输入200字以内"];
    }
    
    if (_historyTextView.text.length == 0) {
        _historyTextView.placeholder = @" 请输入过往病史";
    }
    _infoNumLab.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    !_DescribeSymptomsCell_block ? : _DescribeSymptomsCell_block(textView.text);
}

/*
*第一种方法，简单粗暴
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 不让输入表情
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        if ([DCCheckRegular stringContainsEmoji:textView.text]) {
            return NO;
        }
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
