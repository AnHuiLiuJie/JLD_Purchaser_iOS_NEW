//
//  GLPDetailActBeanController.m
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "GLPDetailActBeanController.h"

@interface GLPDetailActBeanController ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation GLPDetailActBeanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - kScreenH/2, kScreenW, kScreenH/2)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLab.text = self.detailModel.activityInfo.actTitle;
    _titleLab.numberOfLines = 0;
    [_bgView addSubview:_titleLab];
    
    _subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitleLab.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _subTitleLab.font = [UIFont fontWithName:PFRMedium size:18];
    _subTitleLab.text = self.detailModel.activityInfo.actTitle;
    _subTitleLab.numberOfLines = 0;
    [_bgView addSubview:_subTitleLab];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //_iconImage.image = [UIImage imageNamed:@"logo"];
    [_bgView addSubview:_iconImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont fontWithName:PFRMedium size:17];
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_contentLab];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kScreenH/2, 0, 0, 0));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(24);
    }];
    
    [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.bgView.centerX);
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-15); 
        make.top.equalTo(self.titleLab.top).offset(40);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subTitleLab.centerY);
        make.right.equalTo(self.subTitleLab.left).offset(-5);
        make.size.equalTo(CGSizeMake(18, 20));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.bgView.top).offset(20);
        //make.centerY.equalTo(self.subTitleLab.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLab.bottom).offset(20);
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-15);
    }];
    
    __block NSString *title = @"";
    __block NSString *subTitle = @"";
    __block NSString *content = @"";
    [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
        if([actModel.actType isEqualToString:@"fullMinus"]) {
            title = actModel.actTitle;
            subTitle = [NSString stringWithFormat:@"活动截至到 %@ 结束",actModel.endTime];
            __block NSString *tips = @"";
            [actModel.tips enumerateObjectsUsingBlock:^(NSString *_Nonnull title,NSUInteger idx, BOOL *_Nonnull stop) {
                tips = [NSString stringWithFormat:@"%@元\n%@",title,tips];
            }];
            content = [NSString stringWithFormat:@"凡在活动期间购买本活动商品\n%@时间有限，快来抢购吧~",tips];
       }
    }];
    
    self.titleLab.text = title;
    
    self.subTitleLab.text = subTitle;
    
    self.contentLab.text = content;
}


#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
