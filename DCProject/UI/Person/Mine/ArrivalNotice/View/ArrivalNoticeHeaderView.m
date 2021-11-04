//
//  ArrivalNoticeHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/7/6.
//

#import "ArrivalNoticeHeaderView.h"
#import "YBPopupMenu.h"
@interface ArrivalNoticeHeaderView ()<YBPopupMenuDelegate>


@end

@implementation ArrivalNoticeHeaderView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //圆角
    [DCSpeedy dc_changeControlCircularWith:_promptView AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];

    
    [DCSpeedy dc_changeControlCircularWith:_topBgView AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_bottomBgView AndSetCornerRadius:15 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_timeBgView AndSetCornerRadius:6 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_LineColor] canMasksToBounds:YES];
    
    self.phoneBgView_H_LayoutConstraint.constant = 0;
    self.phoneBgView.hidden = YES;
    
    [_smsSwitch addTarget:self action:@selector(smsSwitchAction:) forControlEvents:UIControlEventValueChanged];

    [_phoneTf addTarget:self action:@selector(phone_tfDidChange:) forControlEvents:UIControlEventEditingChanged];

    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _timeBgView.tag = 0;
    _timeBgView.userInteractionEnabled = YES;
    [_timeBgView addGestureRecognizer:tapGesture1];
}

- (void)phone_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 11) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:11];
    }
    !_ArrivalNoticeHeaderView_block3 ? : _ArrivalNoticeHeaderView_block3(textField.text);
}

#pragma mark - set
-(void)setTimeArr:(NSArray *)timeArr{
    _timeArr = timeArr;
}

-(void)setModel:(ArrivalNoticeModel *)model{
    _model = model;
    if ([_model.isSms isEqualToString:@"1"]) {
        [_smsSwitch setOn:YES];
    }else
        [_smsSwitch setOn:NO];
    
    [self smsSwitchAction:_smsSwitch];
    if (model.buyerCellphone.length > 0) {
        _phoneTf.text = _model.buyerCellphone;
    }
    
    if (model.iD.length > 0) {
        self.promptView.hidden = NO;
        self.promptView_H_LayoutConstraint.constant = 52;
        self.topBgView_Y_LayoutConstraint.constant = 10;
    }else{
        self.promptView.hidden = YES;
        self.promptView_H_LayoutConstraint.constant = 0;
        self.topBgView_Y_LayoutConstraint.constant = -52;
    }
    
    
//    if (_model.buyerCellphone.length > 4) {
//        _phoneTf.text = [NSString stringWithFormat:@"%@ **** %@",[_model.buyerCellphone substringToIndex:3],[_model.buyerCellphone substringFromIndex:_model.buyerCellphone.length-4]];
//    }
    
    if (_model.expectTime.length !=0 ) {
        
        __block NSString *timeStr = _model.expectTime;
        [_timeArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj[@"key"] isEqualToString:_model.expectTime]) {
                timeStr = obj[@"value"];
            }
        }];
        _timeLab.text = [NSString stringWithFormat:@"%@",timeStr];

        _timePre.hidden = NO;
        NSDate *date = [NSDate date];
        NSDate *startDate = [DCSpeedy offsetDay:[_model.expectTime intValue] date:date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _timePre.text = [NSString stringWithFormat:@"%@之前到货通知您",[formatter stringFromDate:startDate]];
    }else
        _timePre.hidden = YES;

}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    CGAffineTransform transform = _arrowImg.transform;
    if (transform.d < 0) {
        _arrowImg.transform = CGAffineTransformMakeScale(1,1);
    }
    else
        _arrowImg.transform = CGAffineTransformMakeScale(1,-1);
    
    UIView *views = (UIView*) gestureRecognizer.view;
    NSUInteger tag = views.tag;
    
    _timeBgView.tag = tag == 0 ? 1 : 0;
    if (_timeBgView.tag == 1) {
        !_ArrivalNoticeHeaderView_block ? : _ArrivalNoticeHeaderView_block(@"1");
        [self showPopupMenu];
    } else{
        !_ArrivalNoticeHeaderView_block ? : _ArrivalNoticeHeaderView_block(@"0");
    }
}

#pragma mark - 展示弹框  选中的cell样式可自定义  待优化 kNavBarHeight
- (void)showPopupMenu {
    if (_timeArr.count == 0) {
        return;
    }
    NSMutableArray *newarr = [NSMutableArray array];
    [_timeArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [newarr addObject:obj[@"value"]];
    }];
    YBPopupMenu *popupMenu = [YBPopupMenu showAtPoint:CGPointMake(_timeBgView.dc_x+_timeBgView.dc_width/2+15,_timeBgView.dc_bottom+kNavBarHeight+15+self.promptView_H_LayoutConstraint.constant+15) titles:newarr icons:@[] menuWidth:_timeBgView.dc_width delegate:self];
    popupMenu.dismissOnSelected = YES;
    popupMenu.backgroundColor = [UIColor whiteColor];
    popupMenu.isShowShadow = NO;
    popupMenu.delegate = self;
    popupMenu.offset = 0;
    popupMenu.type = YBPopupMenuTypeDefault;
    popupMenu.fontSize = 14;
    popupMenu.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    popupMenu.borderWidth = 0;
    popupMenu.cornerRadius = 5;
    popupMenu.minSpace = 0;
    popupMenu.arrowPosition = YBPopupMenuPriorityDirectionLeft;
    popupMenu.backColor = [UIColor whiteColor];
    popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
}

#pragma mark - <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    //NSLog(@"YBPopupMenuDelegate %ld",index);
    NSDictionary *dic = _timeArr[index];
    _timeLab.text = [NSString stringWithFormat:@"%@",dic[@"value"]];

    _timePre.hidden = NO;
    NSDate *date = [NSDate date];
    NSDate *startDate = [DCSpeedy offsetDay:[dic[@"key"] intValue] date:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _timePre.text = [NSString stringWithFormat:@"%@之前到货通知您",[formatter stringFromDate:startDate]];
    !_ArrivalNoticeHeaderView_block2 ? : _ArrivalNoticeHeaderView_block2(dic[@"key"]);

    _timeBgView.tag = 0;
    _arrowImg.transform = CGAffineTransformMakeScale(1,1);
}

- (void)ybPopupMenuDidDismiss{
    _timeBgView.tag = 0;
    _arrowImg.transform = CGAffineTransformMakeScale(1,1);
}

#pragma mark - 默认
- (void)smsSwitchAction:(id)sender
{
    BOOL isButtonOn1 = [sender isOn];
    if (isButtonOn1) {
        self.phoneBgView_H_LayoutConstraint.constant = 45;
        self.phoneBgView.hidden = NO;
    }else{
        self.phoneBgView_H_LayoutConstraint.constant = 0;
        self.phoneBgView.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
