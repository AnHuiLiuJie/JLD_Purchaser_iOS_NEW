//
//  GLPCheckEvaluationVC.m
//  DCProject
//
//  Created by LiuMac on 2021/10/21.
//

#import "GLPCheckEvaluationVC.h"
// Controllers
// Models
// Views
/* cell */
#import "GLPBankCardCell.h"
/* head */
/* foot */
// Vendors
// Categories
// Others

static NSString *const GLPBankCardCellID = @"GLPBankCardCell";

@interface GLPCheckEvaluationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;


@end

@implementation GLPCheckEvaluationVC

#pragma mark - 请求
- (void)requestLoadData:(NSInteger )type{
    
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.title = @"评价";
    self.submitBtn.hidden = NO;
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F8F9FB"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPBankCardCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - <UITableViewDelegate>
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 420;
//}

#pragma mark - 确定 保存并使用
- (void)submitBtnAction:(UIButton *)button
{
    [self requestLoadData:1];
}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        //_tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-self.submitBtn.dc_height);
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:GLPBankCardCellID bundle:nil] forCellReuseIdentifier:GLPBankCardCellID];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _submitBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-20-45, kScreenW-30, 45);
        [DCSpeedy dc_changeControlCircularWith:_submitBtn AndSetCornerRadius:_submitBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_submitBtn];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = _submitBtn.bounds;
        [_submitBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [_submitBtn dc_cornerRadius:_submitBtn.dc_height/2];
    }
    return _submitBtn;
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/*
#pragma mark - Navigation

// In a storyboard-based submit, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
