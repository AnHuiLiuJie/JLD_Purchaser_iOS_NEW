//
//  HealthInformationView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/9.
//

#import "HealthInformationView.h"
#import "UITextView+placeholder.h"

@interface HealthInformationView()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;


@end

@implementation HealthInformationView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
        
        self.contentView.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.4f];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(15, _bgView.dc_height/2)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [self.bgView.window addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender{
  if (sender.state == UIGestureRecognizerStateEnded){
    CGPoint location = [sender locationInView:nil];
    if (![self.bgView pointInside:[self.bgView convertPoint:location fromView:self.bgView.window] withEvent:nil]){
        [self.bgView.window removeGestureRecognizer:sender];
        [self dismissWithAnimation:YES];

    }
  }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"HealthInformationView" owner:self options:nil] lastObject];
    _contentView.frame = self.bounds;
    [self addSubview:_contentView];
    
    [self showWithAnimation:YES];
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.historyNoBtn.selected = YES;
    self.history_H_LayoutConstraint.constant = 0;
    self.historyInfoBgView.hidden = YES;
    _historyLine.hidden = NO;
    self.historyYesBtn.selected = NO;
    [self.historyNoBtn addTarget:self action:@selector(history_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.historyYesBtn addTarget:self action:@selector(history_Action1:) forControlEvents:UIControlEventTouchUpInside];

    self.allergicNoBtn.selected = YES;
    self.allergic_H_LayoutConstraint.constant = 0;
    self.allergicBgView.hidden = YES;
    _allergicLine.hidden = NO;
    self.allergicYesBtn.selected = NO;
    [self.allergicNoBtn addTarget:self action:@selector(allergic_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.allergicYesBtn addTarget:self action:@selector(allergic_Action1:) forControlEvents:UIControlEventTouchUpInside];

    self.illnessNoBtn.selected = YES;
    self.illness_H_LayoutConstraint.constant = 0;
    self.illnessBgView.hidden = YES;
    _illnessLine.hidden = NO;
    self.illnessYesBtn.selected = NO;
    [self.illnessNoBtn addTarget:self action:@selector(illness_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.illnessYesBtn addTarget:self action:@selector(illness_Action1:) forControlEvents:UIControlEventTouchUpInside];

    self.liverNoBtn.selected = YES;
    self.liverYesBtn.selected = NO;
    [self.liverNoBtn addTarget:self action:@selector(liver_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.liverYesBtn addTarget:self action:@selector(liver_Action1:) forControlEvents:UIControlEventTouchUpInside];

    self.renalNoBtn.selected = YES;
    self.renalYesBtn.selected = NO;
    [self.renalNoBtn addTarget:self action:@selector(renal_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.renalYesBtn addTarget:self action:@selector(renal_Action1:) forControlEvents:UIControlEventTouchUpInside];

    self.lactationNoBtn.selected = YES;
    self.lactationYesBtn.selected = NO;
    [self.lactationNoBtn addTarget:self action:@selector(lactation_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.lactationYesBtn addTarget:self action:@selector(lactation_Action1:) forControlEvents:UIControlEventTouchUpInside];

    [self.saveBtn addTarget:self action:@selector(save_Action:) forControlEvents:UIControlEventTouchUpInside];
    [DCSpeedy dc_changeControlCircularWith:self.saveBtn AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:NO];
    

    //编辑内容
    self.historyTextView.delegate = self;
    self.historyTextView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [DCSpeedy dc_changeControlCircularWith:self.historyTextView AndSetCornerRadius:8 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];
    self.historyTextView.font = [UIFont systemFontOfSize:14];
    self.historyTextView.placeholder = @"请输入过往病史";
    _infoNumLab.text = @"  0/100";
    
    
    self.allergicTextView.delegate = self;
    self.allergicTextView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [DCSpeedy dc_changeControlCircularWith:self.allergicTextView AndSetCornerRadius:8 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];
    self.allergicTextView.font = [UIFont systemFontOfSize:14];
    self.allergicTextView.placeholder = @"请输入过敏史";
    _allergicNumLab.text = @"  0/100";
    
    
    self.illnessTextView.delegate = self;
    self.illnessTextView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [DCSpeedy dc_changeControlCircularWith:self.illnessTextView AndSetCornerRadius:8 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];
    self.illnessTextView.font = [UIFont systemFontOfSize:14];
    self.illnessTextView.placeholder = @"请输入家族病史";
    _illnessNumLab.text = @"  0/100";
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGFloat H = self.history_H_LayoutConstraint.constant + self.allergic_H_LayoutConstraint.constant + self.illness_H_LayoutConstraint.constant;
//    if (H > 0) {
//        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.dc_width, self.bgScrollView.dc_height+80);
//    }
//}

#pragma mark - set model

-(void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    if ([model.isNowIllness isEqualToString:@"1"]) {
        [self history_Action1:self.historyYesBtn];
        _historyTextView.text = model.nowIllness;
        _infoNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)model.nowIllness.length];
        _historyTextView.placeholder = @"";
    }
    
    if ([model.isHistoryAllergic isEqualToString:@"1"]) {
        [self allergic_Action1:self.allergicYesBtn];
        _allergicTextView.text = model.historyAllergic;
        _allergicNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)model.historyAllergic.length];
        _allergicTextView.placeholder = @"";
    }
    
    if ([model.isHistoryIllness isEqualToString:@"1"]) {
        [self illness_Action1:self.illnessYesBtn];
        _illnessTextView.text = model.historyIllness;
        _illnessNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)model.historyIllness.length];
        _illnessTextView.placeholder = @"";
    }
    
    if ([model.liverUnusual isEqualToString:@"1"]) {
        [self liver_Action1:self.liverYesBtn];
    }
    
    if ([model.renalUnusual isEqualToString:@"1"]) {
        [self renal_Action1:self.renalYesBtn];
    }
    
    if ([model.lactationFlag isEqualToString:@"1"]) {
        [self lactation_Action1:self.lactationYesBtn];
    }
    
    [self changeDefineBtnState];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self changeDefineBtnState];
    if (textView.text.length > 100) {
        ((UITextView *)textView).text = [((UITextView *)textView).text substringToIndex:100];
        [SVProgressHUD showInfoWithStatus:@"请输入100字以内"];
    }
    
    if ([textView isEqual:_historyTextView]) {
        if (_historyTextView.text.length == 0) {
            _historyTextView.placeholder = @"请输入过往病史";
        }
        self.model.nowIllness = textView.text;
        _infoNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    }else if([textView isEqual:_allergicTextView]){
        if (_allergicTextView.text.length == 0) {
            _allergicTextView.placeholder = @"请输入过敏史";
        }
        self.model.historyAllergic = textView.text;
        _allergicNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    }else if([textView isEqual:_illnessTextView]){
        if (_illnessTextView.text.length == 0) {
            _illnessTextView.placeholder = @"请输入家族病史";
        }
        self.model.historyIllness = textView.text;
        _illnessNumLab.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
    }

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

#pragma mark -  ********************   but  action ********************
- (void)history_Action:(UIButton *)button{
    self.historyNoBtn.selected = YES;
    self.historyYesBtn.selected = NO;
    self.history_H_LayoutConstraint.constant = 0;
    self.historyInfoBgView.hidden = YES;
    _historyLine.hidden = NO;
    self.model.isNowIllness = @"2";
    [self changeDefineBtnState];
}
- (void)history_Action1:(UIButton *)button{
    self.historyNoBtn.selected = NO;
    self.historyYesBtn.selected = YES;
    self.history_H_LayoutConstraint.constant = 80;
    self.historyInfoBgView.hidden = NO;
    _historyLine.hidden = YES;
    self.model.isNowIllness = @"1";
    [self changeDefineBtnState];
}

- (void)allergic_Action:(UIButton *)button{
    self.allergicNoBtn.selected = YES;
    self.allergicYesBtn.selected = NO;
    self.allergic_H_LayoutConstraint.constant = 0;
    self.allergicBgView.hidden = YES;
    _allergicLine.hidden = NO;
    self.model.isHistoryAllergic = @"2";
    [self changeDefineBtnState];
}
- (void)allergic_Action1:(UIButton *)button{
    self.allergicNoBtn.selected = NO;
    self.allergicYesBtn.selected = YES;
    self.allergic_H_LayoutConstraint.constant = 80;
    self.allergicBgView.hidden = NO;
    _allergicLine.hidden = YES;
    self.model.isHistoryAllergic = @"1";
    [self changeDefineBtnState];
}

- (void)illness_Action:(UIButton *)button{
    self.illnessNoBtn.selected = YES;
    self.illnessYesBtn.selected = NO;
    self.illness_H_LayoutConstraint.constant = 0;
    self.illnessBgView.hidden = YES;
    _illnessLine.hidden = NO;
    self.model.isHistoryIllness = @"2";
    [self changeDefineBtnState];
}
- (void)illness_Action1:(UIButton *)button{
    self.illnessNoBtn.selected = NO;
    self.illnessYesBtn.selected = YES;
    self.illness_H_LayoutConstraint.constant = 80;
    self.illnessBgView.hidden = NO;
    _illnessLine.hidden = YES;
    self.model.isHistoryIllness = @"1";
    [self changeDefineBtnState];
}


- (void)liver_Action:(UIButton *)button{
    self.liverNoBtn.selected = YES;
    self.liverYesBtn.selected = NO;
    self.model.liverUnusual = @"2";
}
- (void)liver_Action1:(UIButton *)button{
    self.liverNoBtn.selected = NO;
    self.liverYesBtn.selected = YES;
    self.model.liverUnusual = @"1";
}


- (void)renal_Action:(UIButton *)button{
    self.renalNoBtn.selected = YES;
    self.renalYesBtn.selected = NO;
    self.model.renalUnusual = @"2";
}
- (void)renal_Action1:(UIButton *)button{
    self.renalNoBtn.selected = NO;
    self.renalYesBtn.selected = YES;
    self.model.renalUnusual = @"1";
}

- (void)lactation_Action:(UIButton *)button{
    self.lactationNoBtn.selected = YES;
    self.lactationYesBtn.selected = NO;
    self.model.lactationFlag = @"2";
}
- (void)lactation_Action1:(UIButton *)button{
    self.lactationNoBtn.selected = NO;
    self.lactationYesBtn.selected = YES;
    self.model.lactationFlag = @"1";
}

#pragma 保存
- (void)save_Action:(UIButton *)button{
    [self isActiveState:YES];
    !_HealthInformationView_Block ? : _HealthInformationView_Block(self.model);
    [self dismissWithAnimation:YES];
}

- (BOOL)isActiveState:(BOOL)isNeedToast{
    if ([self.model.isNowIllness isEqualToString:@"1"]) {
        if (self.model.nowIllness.length == 0) {
            !isNeedToast ?  : [self makeToast:@"请输入过往病史" duration:Toast_During position:CSToastPositionBottom];
            return NO;
        }
    }else
        self.model.nowIllness = @"";
    
    if ([self.model.isHistoryAllergic isEqualToString:@"1"]) {
        if (self.model.historyAllergic.length == 0) {
            !isNeedToast ?  : [self makeToast:@"请输入过敏史" duration:Toast_During position:CSToastPositionBottom];
            return NO;
        }
    }else
        self.model.historyAllergic = @"";
    
    if ([self.model.isHistoryIllness isEqualToString:@"1"]) {
        if (self.model.historyIllness.length == 0) {
            !isNeedToast ?  : [self makeToast:@"请输入家族病史" duration:Toast_During position:CSToastPositionBottom];
            return NO;
        }
    }else
        self.model.historyIllness = @"";
    
    return YES;
}

- (void)changeDefineBtnState{
    BOOL isYES = [self isActiveState:NO];
    if (isYES) {
        self.saveBtn.userInteractionEnabled = YES;
        self.saveBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    }else{
        self.saveBtn.userInteractionEnabled = NO;
        self.saveBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#b9b9b9"];
    }
}

#pragma 取消
- (IBAction)click_cancelBtnAction:(id)sender {

    [self dismissWithAnimation:YES];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    //UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    //[keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.bgView.frame;
        rect.origin.y = kScreenH;
        self.bgView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.bgView.frame;
            rect.origin.y -= kScreenH + kNavBarHeight + LJ_TabbarSafeBottomMargin;
            self.bgView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += kScreenH + kNavBarHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.frame = rect;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
