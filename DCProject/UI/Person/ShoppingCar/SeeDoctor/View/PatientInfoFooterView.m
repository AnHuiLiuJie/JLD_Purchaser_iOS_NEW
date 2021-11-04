//
//  PatientInfoFooterView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/10.
//

#import "PatientInfoFooterView.h"


@interface PatientInfoFooterView()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation PatientInfoFooterView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

#pragma mark - initialize
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //[self setupViewUI];
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"PatientInfoFooterView" owner:self options:nil] lastObject];
    _contentView.frame = self.bounds;
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    [self setupViewUI];
}

- (void)setupViewUI
{
    _nowIllnessLab.font = [UIFont fontWithName:PFR size:14];
    _historyAllergicLab.font = [UIFont fontWithName:PFR size:14];
    _historyIllnessLab.font = [UIFont fontWithName:PFR size:14];

    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(10, 1)];
    //[self layoutIfNeeded];
}

- (void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    if ([model.isNowIllness isEqualToString:@"1"]) {
        _nowIllnessLab.text = model.nowIllness;
    }else
        _nowIllnessLab.text = @"无";
    
    if ([model.isHistoryAllergic isEqualToString:@"1"]) {
        _historyAllergicLab.text = model.historyAllergic;
    }else
        _historyAllergicLab.text = @"无";
    
    if ([model.isHistoryIllness isEqualToString:@"1"]) {
        _historyIllnessLab.text = model.historyIllness;
    }else
        _historyIllnessLab.text = @"无";
    
    
    if ([model.liverUnusual isEqualToString:@"1"]) {
        _liverUnusualLab.text = @"有";
    }else
        _liverUnusualLab.text = @"否";
    
    if ([model.renalUnusual isEqualToString:@"1"]) {
        _renalUnusualLab.text = @"有";
    }else
        _renalUnusualLab.text = @"否";
    
    if ([model.lactationFlag isEqualToString:@"1"]) {
        _lactationFlagLab.text = @"有";
    }else
        _lactationFlagLab.text = @"否";
    
    [self.bgView layoutIfNeeded];

    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
