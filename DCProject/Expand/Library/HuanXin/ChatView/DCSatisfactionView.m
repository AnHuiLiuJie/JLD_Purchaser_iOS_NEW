//
//  DCSatisfactionView.m
//  DCProject
//
//  Created by LiuMac on 2021/5/6.
//

#import "DCSatisfactionView.h"
#import "CWStarRateView.h"
#import "HEvaluationTagView.h"
#import "HAppraiseTagsModel.h"
#import "ReasonEvaluationView.h"
#import "UIView+HDHUD.h"

@interface DCSatisfactionView()<CWStarRateViewDelegate,HEvaluationTagSelectDelegate,ReasonEvaluationViewDelegate>

@property (strong, nonatomic)  UIView *bgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CWStarRateView *starRateView;
@property (nonatomic, strong) UILabel *evaluateTitle;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) ReasonEvaluationView *reasonEvaluationView;
@property (nonatomic, strong) HEvaluationTagView *evaluationTagView;
@property (nonatomic, strong) NSMutableDictionary *evaluationTagsDict;
@property (nonatomic, strong) NSMutableArray *evaluationTagsArray;
@property (nonatomic, strong) NSMutableArray *reasonTagsArray;

@end

static CGFloat const kPickerHeight = 360;
static CGFloat const kViewSpace = 5;

@implementation DCSatisfactionView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
        self.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.5f];

        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, self.dc_height-kPickerHeight-LJ_TabbarSafeBottomMargin, self.dc_width, kPickerHeight+LJ_TabbarSafeBottomMargin);
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(5, _bgView.dc_height/2)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
        [self addGestureRecognizer:tapGesture];
    
        [self showWithAnimation:YES];
    }
    return self;
}

- (void)setMessageModel:(id<HDIMessageModel>)messageModel{
    _messageModel = messageModel;
    [self setTopHeaderView];
}


- (void)templateSingleTapAction:(id)sender
{
    //[self dismissWithAnimation:YES];
}

#pragma mark - setViewUI

- (void)setTopHeaderView
{
    [self.bgView addSubview:self.textLabel];
    [self.bgView addSubview:self.starRateView];
    [self.bgView addSubview:self.evaluateTitle];
    [self.bgView addSubview:self.reasonEvaluationView];
    [self.bgView addSubview:self.evaluationTagView];
    
    self.commitBtn.hidden = NO;

    self.evaluateTitle.text = @"非常满意";
    [self parseAppraiseTagExt:1.0];

}

- (NSMutableDictionary *)evaluationTagsDict
{
    if (_evaluationTagsDict == nil) {
        _evaluationTagsDict = [NSMutableDictionary dictionary];
    }
    return _evaluationTagsDict;
}

- (NSMutableArray *)evaluationTagsArray
{
    if (_evaluationTagsArray == nil) {
        _evaluationTagsArray = [NSMutableArray array];
    }
    return _evaluationTagsArray;
}

- (NSMutableArray *)reasonTagsArray
{
    if (_reasonTagsArray == nil) {
        _reasonTagsArray = [NSMutableArray array];
    }
    return _reasonTagsArray;
}

#pragma mark - set
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"请对本次服务进行评价";
        _textLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _textLabel.font = [UIFont fontWithName:PFR size:12];
        _textLabel.frame = CGRectMake(10, 5, _bgView.dc_width-30, 20);
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(_bgView.dc_width-44, 0, 30, 30)];
        [backButton setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back_action) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:backButton];
        
        UIView *line_x = [[UIView alloc] init];
        line_x.frame = CGRectMake(0, 30, _bgView.dc_width, 1);
        line_x.backgroundColor = [UIColor dc_colorWithHexString:@"#ECECEC"];
        [_bgView addSubview:line_x];
    }
    return _textLabel;
}

- (CWStarRateView *)starRateView
{
    if (_starRateView == nil) {
        _starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_textLabel.frame)+ kViewSpace*5, _bgView.dc_width - 30, 30) numberOfStars:5];
        _starRateView.scorePercent = 1.0;
        _starRateView.allowIncompleteStar = YES;
        _starRateView.hasAnimation = YES;
        _starRateView.delegate = self;
    }
    return _starRateView;
}

- (UILabel *)evaluateTitle
{
    if (_evaluateTitle == nil) {
        _evaluateTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_starRateView.frame) + kViewSpace, kHDScreenWidth - 40, 30)];
        _evaluateTitle.textAlignment = NSTextAlignmentCenter;
        _evaluateTitle.font = [UIFont systemFontOfSize:16];
        [_evaluateTitle setTextColor:[UIColor orangeColor]];
    }
    return _evaluateTitle;
}

- (UIView *)reasonEvaluationView
{
    if (_reasonEvaluationView == nil) {
        _reasonEvaluationView = [[ReasonEvaluationView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_evaluateTitle.frame)+kViewSpace, _bgView.dc_width-30, 90)];
        _reasonEvaluationView.delegate = self;
    }
    return _reasonEvaluationView;
}

- (UIView *)evaluationTagView
{
    if (_evaluationTagView == nil) {
        _evaluationTagView = [[HEvaluationTagView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_reasonEvaluationView.frame)+kViewSpace, _bgView.dc_width-30, 80)];
        _evaluationTagView.delegate = self;
    }
    return _evaluationTagView;
}

- (UIButton*)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(_bgView.dc_width/6, _bgView.dc_height-LJ_TabbarSafeBottomMargin-55, _bgView.dc_width/3*2, 40);
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.commitBtn];
        [_commitBtn dc_cornerRadius:_commitBtn.dc_height/2];

        NSArray *clolor = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,
                           nil];
        CAGradientLayer *gradientLayer = [_commitBtn dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@0.3, @0.9] colors:clolor];
        [self.commitBtn.layer addSublayer:gradientLayer];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _commitBtn;
}


#pragma mark - CWStarRateViewDelegate
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    [self parseAppraiseTagExt:newScorePercent];
}


- (void)parseAppraiseTagExt:(CGFloat)ScorePercent
{
    if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
        NSDictionary *weichat = [self.messageModel.message.ext objectForKey:kMessageExtWeChat];
        if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
            NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
            NSLog(@"ctrlArgs--%@", ctrlArgs);
            NSMutableArray *evaluationDegree = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_evaluationDegree];
            NSDictionary *appraiseTagsDict = nil;
            
            NSInteger isGood = 0;// 0 表示未知不选中任何一个 1 表示解决。2表示未解决
            if (ScorePercent == 1.0) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:0];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
                self.reasonEvaluationView.mark = 0;
                isGood = 1;
            } else if (ScorePercent == 0.8) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:1];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
                self.reasonEvaluationView.mark = 0;
                isGood = 1;
            } else if (ScorePercent == 0.6) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:2];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
                self.reasonEvaluationView.mark = 1;
                isGood = 1;
            } else if (ScorePercent == 0.4) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:3];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
                self.reasonEvaluationView.mark = 13;
                isGood = 2;
            } else if (ScorePercent == 0.2) {
                appraiseTagsDict = [evaluationDegree objectAtIndex:4];
                self.evaluateTitle.text = [appraiseTagsDict objectForKey:@"name"];
                self.reasonEvaluationView.mark = 123;
                isGood = 2;
            }
            
            for (NSDictionary *dict in [appraiseTagsDict objectForKey:@"appraiseTags"]) {
                [dict setValue:@"NO" forKey:@"isSelected"];

                NSString *name = [dict objectForKey:@"name"] ;
                if ([name isEqualToString:@"未解决"] && isGood == 2 ) {
                    [dict setValue:@"YES" forKey:@"isSelected"];
                }
                
                if ([name isEqualToString:@"已解决"] && isGood == 1 ) {
                    [dict setValue:@"YES" forKey:@"isSelected"];
                }
            }
            
            HEvaluationDegreeModel *edm = [HEvaluationDegreeModel evaluationDegreeWithDict:appraiseTagsDict];

            self.evaluationTagView.evaluationDegreeModel = edm;
        }
    }
}

#pragma mark - ReasonEvaluationViewDelegate
- (void)dc_evaluationTagSelectWithArray:(NSArray *)tags
{
    if (self.reasonTagsArray) {
        [_reasonTagsArray removeAllObjects];
    }
    
    for (int i = 0; i < tags.count; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        HAppraiseTagsModel *model = tags[i];
        [dict setObject:model.appraiseTagsId forKey:@"id"];
        [dict setObject:model.name forKey:@"name"];
        [self.reasonTagsArray addObject:dict];
    }
}

#pragma mark - HEvaluationTagSelectDelegate
- (void)evaluationTagSelectWithArray:(NSArray *)tags
{
    if (self.evaluationTagsArray) {
        [self.evaluationTagsArray removeAllObjects];
    }
    
    for (int i = 0; i < tags.count; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        HAppraiseTagsModel *model = tags[i];
        [dict setObject:model.appraiseTagsId forKey:@"id"];
        [dict setObject:model.name forKey:@"name"];
        [self.evaluationTagsArray addObject:dict];
    }

}

#pragma mark - action

- (void)back_action
{
    [self dismissWithAnimation:YES];
}

- (void)commitAction
{
    if (!_starRateView.isTap && _starRateView.scorePercent != 1) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"satisfaction.alert", @"please evaluate first") preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancela", @"Cancel") style:UIAlertActionStyleDefault handler:nil]];
        [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleCancel handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
        
        return;
    }
    if ([self.delegate respondsToSelector:@selector(commitSatisfactionWithControlArguments:type:reasonArray:evaluationTagsArray:evaluationDegreeId:)]) {
        if ([self.messageModel.message.ext objectForKey:kMessageExtWeChat]) {
            HDMessage *msg = self.messageModel.message;
            NSDictionary *weichat = [msg.ext objectForKey:kMessageExtWeChat];
            if ([weichat objectForKey:kMessageExtWeChat_ctrlArgs]) {
                NSMutableDictionary *ctrlArgs = [NSMutableDictionary dictionaryWithDictionary:[weichat objectForKey:kMessageExtWeChat_ctrlArgs]];
                ControlType *type = [[ControlType alloc] initWithValue:@"enquiry"];
                ControlArguments *arguments = [ControlArguments new];
                arguments.sessionId = [msg.ext objectForKey:kMessageExtWeChat_ctrlArgs_serviceSessionId];
                if (!arguments.sessionId) {
                    if (msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"]) {
                        arguments.sessionId = msg.ext[@"weichat"][@"service_session"][@"serviceSessionId"];
                    }
                }
                arguments.inviteId = [ctrlArgs objectForKey:kMessageExtWeChat_ctrlArgs_inviteId];
                //arguments.detail = self.textView.text;
                arguments.summary = [NSString stringWithFormat:@"%d",(int)(_starRateView.scorePercent *5)];
                if ([arguments.summary integerValue] < 3 && self.reasonTagsArray.count == 0 ) {
                    //[SVProgressHUD showInfoWithStatus:@"至少选择一个标签"];
                    [self showHint:NSLocalizedString(@"select_at_least_one_tag", @"Select at least one tag!")];
                }else{
                    [self.delegate commitSatisfactionWithControlArguments:arguments
                                                                     type:type
                                                              reasonArray:self.reasonTagsArray
                                                      evaluationTagsArray:self.evaluationTagsArray evaluationDegreeId:self.evaluationTagView.evaluationDegreeModel.evaluationDegreeId];
                     [self back_action];
                }
//                if (self.evaluationTagsArray.count == 0 &&self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0) {
//
//                } else {
//
//                }

            }
        }
    }
//    if (self.evaluationTagView.evaluationDegreeModel.appraiseTags.count>0 &&
//        self.evaluationTagsArray.count == 0) {
//        
//    } else {
//         [self back_action];
//    }
    
}
//#pragma mark - 弹出视图方法
//- (void)showWithAnimation:(BOOL)animation {
//    //1. 获取当前应用的主窗口
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    [keyWindow addSubview:self];
//    if (animation) {
//        // 动画前初始位置
//        CGRect rect = self.bgView.frame;
//        rect.origin.y = SCREEN_HEIGHT;
//        self.bgView.frame = rect;
//        // 浮现动画
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = self.bgView.frame;
//            rect.origin.y -= SCREEN_HEIGHT + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
//            self.bgView.frame = rect;
//        }];
//    }
//}
//

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.bgView.frame;
        rect.origin.y = kScreenH;
        self.bgView.frame = rect;
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.bgView.frame;
            rect.origin.y -= kPickerHeight + LJ_TabbarSafeBottomMargin;
            self.bgView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y += kPickerHeight + LJ_TabbarSafeBottomMargin;
        self.bgView.frame = rect;
        self.alpha = 0;
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
