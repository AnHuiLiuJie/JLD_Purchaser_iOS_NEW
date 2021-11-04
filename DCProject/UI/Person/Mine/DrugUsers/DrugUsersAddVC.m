//
//  DrugUsersAddVC.m
//  DCProject
//
//  Created by Apple on 2021/3/18.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "DrugUsersAddVC.h"
#import "STPickerDate.h"
#import "DCTextField.h"
@interface DrugUsersAddVC ()<STPickerDateDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) DCTextField *nameTF;
@property (nonatomic,strong) DCTextField *cardTF;
@property (nonatomic,strong) DCTextField *birthdayTF;
@property (nonatomic,strong) UIButton *genderNanBtn;
@property (nonatomic,strong) UIButton *genderNvBtn;
@property (nonatomic,strong) DCTextField *weightTF;
@property (nonatomic,strong) DCTextField *phoneTF;
@property (nonatomic,strong) DCTextField *diseaseTF;
@property (nonatomic,strong) UIView *gxDetailview;
@property (nonatomic,strong) NSArray *gxArray;
@property (nonatomic,strong) NSMutableArray *selectGxArray;

@property (nonatomic,strong) STPickerDate *pickerDate;

@end

@implementation DrugUsersAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.model) {
        self.title = @"编辑用药人";
    }else{
        self.title = @"新增用药人";
    }
    
}

- (void)setupUI{
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFADC"];
    [self.view addSubview:headView];
    [headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    UILabel *headLab = [[UILabel alloc] init];
    headLab.text = @"根据国家药监局规定,购买处方药需要实名认证  根据国家药监局规定,购买处方药需要实名认证";
    headLab.textColor = [UIColor dc_colorWithHexString:@"#FFC100"];
    headLab.numberOfLines = 0;
    [headView addSubview:headLab];
    headLab.font = [UIFont systemFontOfSize:13];
    [headLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).offset(UIEdgeInsetsMake(6, 15, 6, 15));
    }];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(70);
    }];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(addBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"保存并使用" forState:0];
    [addBtn setTitleColor:[UIColor whiteColor] forState:0];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 25;
    addBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [footView addSubview:addBtn];
    [addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footView).offset(UIEdgeInsetsMake(10, 30, 10, 30));
    }];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(footView.top);
    }];
    
    UIView *view = [[UIView alloc] init];
    [self.scrollView addSubview:view];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.size.equalTo(CGSizeMake(kScreenW, 1));
    }];
    
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.text = @"用药人姓名";
    nameLB.font = [UIFont systemFontOfSize:16];
    nameLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    nameLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:nameLB];
    [nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.nameTF = [[DCTextField alloc] init];
    self.nameTF.placeholder = @"请输入姓名";
    self.nameTF.font = [UIFont systemFontOfSize:16];
    self.nameTF.type = DCTextFieldTypeDefault;
    self.nameTF.textAlignment = NSTextAlignmentRight;
    self.nameTF.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [self.scrollView addSubview:self.nameTF];
    [self.nameTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.bottom);
        make.left.equalTo(nameLB.right).offset(10);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIView *nameview = [[UIView alloc] init];
    nameview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:nameview];
    [nameview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTF.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    //身份证号
    UILabel *cardLB = [[UILabel alloc] init];
    cardLB.text = @"身份证号码";
    cardLB.font = [UIFont systemFontOfSize:16];
    cardLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    cardLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:cardLB];
    [cardLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.cardTF = [[DCTextField alloc] init];
    self.cardTF.placeholder = @"请输入身份证号";
    self.cardTF.font = [UIFont systemFontOfSize:16];
    self.cardTF.type = DCTextFieldTypeIDCard;
    self.cardTF.textAlignment = NSTextAlignmentRight;
    self.cardTF.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [self.scrollView addSubview:self.cardTF];
    [self.cardTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameview.bottom);
        make.left.equalTo(cardLB.right).offset(10);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIView *cardview = [[UIView alloc] init];
    cardview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:cardview];
    [cardview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardTF.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    //出生年月日
    UILabel *birthdayLB = [[UILabel alloc] init];
    birthdayLB.text = @"出生年月日";
    birthdayLB.font = [UIFont systemFontOfSize:16];
    birthdayLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    birthdayLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:birthdayLB];
    [birthdayLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.birthdayTF = [[DCTextField alloc] init];
    self.birthdayTF.placeholder = @"请选择出生年月日";
    self.birthdayTF.font = [UIFont systemFontOfSize:16];
    self.birthdayTF.textAlignment = NSTextAlignmentRight;
    self.birthdayTF.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [self.scrollView addSubview:self.birthdayTF];
    [self.birthdayTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardview.bottom);
        make.left.equalTo(cardLB.right).offset(10);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIButton *birthdyBtn = [[UIButton alloc] init];
    [birthdyBtn addTarget:self action:@selector(birthdyBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:birthdyBtn];
    [birthdyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.birthdayTF);
    }];
    
    UIView *birthdayview = [[UIView alloc] init];
    birthdayview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:birthdayview];
    [birthdayview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayTF.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    
    //性别
    UILabel *genderLB = [[UILabel alloc] init];
    genderLB.text = @"性别";
    genderLB.font = [UIFont systemFontOfSize:16];
    genderLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    genderLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:genderLB];
    [genderLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(birthdayview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.genderNvBtn = [[UIButton alloc] init];
    [self.genderNvBtn setImage:[UIImage imageNamed:@"yyrweixuan"] forState:0];
    [self.genderNvBtn setImage:[UIImage imageNamed:@"yyrxuanz"] forState:UIControlStateSelected];
    [self.genderNvBtn setTitle:@"  女" forState:0];
    [self.genderNvBtn setTitleColor:[UIColor dc_colorWithHexString:@"#131217"] forState:0];
    [self.genderNvBtn addTarget:self action:@selector(genderMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.genderNvBtn];
    [self.genderNvBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(birthdayview.bottom);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    self.genderNanBtn = [[UIButton alloc] init];
    [self.genderNanBtn setImage:[UIImage imageNamed:@"yyrweixuan"] forState:0];
    [self.genderNanBtn setImage:[UIImage imageNamed:@"yyrxuanz"] forState:UIControlStateSelected];
    [self.genderNanBtn setTitle:@"  男" forState:0];
    [self.genderNanBtn setTitleColor:[UIColor dc_colorWithHexString:@"#131217"] forState:0];
    [self.genderNanBtn addTarget:self action:@selector(genderMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.genderNanBtn];
    [self.genderNanBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(birthdayview.bottom);
        make.height.equalTo(50);
        make.right.equalTo(self.genderNvBtn.left).offset(-10);
    }];
    
    UIView *genderview = [[UIView alloc] init];
    genderview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:genderview];
    [genderview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.genderNvBtn.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    //体重
    UILabel *weightLB = [[UILabel alloc] init];
    weightLB.text = @"体重";
    weightLB.font = [UIFont systemFontOfSize:16];
    weightLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    weightLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:weightLB];
    [weightLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.weightTF = [[DCTextField alloc] init];
    self.weightTF.placeholder = @"请输入体重";
    self.weightTF.font = [UIFont systemFontOfSize:16];
    self.weightTF.textAlignment = NSTextAlignmentRight;
    self.weightTF.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [self.scrollView addSubview:self.weightTF];
    [self.weightTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderview.bottom);
        make.left.equalTo(weightLB.right).offset(10);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIView *weightview = [[UIView alloc] init];
    weightview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:weightview];
    [weightview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weightTF.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    
    //手机号
    UILabel *phoneLB = [[UILabel alloc] init];
    phoneLB.text = @"手机号";
    phoneLB.font = [UIFont systemFontOfSize:16];
    phoneLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    phoneLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:phoneLB];
    [phoneLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.phoneTF = [[DCTextField alloc] init];
    self.phoneTF.placeholder = @"请输入手机号";
    self.phoneTF.font = [UIFont systemFontOfSize:16];
    self.phoneTF.textAlignment = NSTextAlignmentRight;
    self.phoneTF.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [self.scrollView addSubview:self.phoneTF];
    [self.phoneTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightview.bottom);
        make.left.equalTo(phoneLB.right).offset(10);
        make.height.equalTo(50);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIView *phoneview = [[UIView alloc] init];
    phoneview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:phoneview];
    [phoneview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
    
    
    
    //关系
    UILabel *gxLB = [[UILabel alloc] init];
    gxLB.text = @"关系";
    gxLB.font = [UIFont systemFontOfSize:16];
    gxLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    gxLB.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:gxLB];
    [gxLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneview.bottom);
        make.left.equalTo(view).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.gxDetailview = [[UIView alloc] init];
    [self.scrollView addSubview:self.gxDetailview];
    self.gxArray = @[@"本人",@"家属",@"亲戚",@"朋友"];
    int w = 0;
    int h = 10;
    int scrollViewW = kScreenW - 160;
    for (int i = 0; i< self.gxArray.count; i++) {
        if (h+70 > scrollViewW) {
            h+=40;
            w = 0;
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w, h, 60, 30)];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(gxMethod:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.gxArray[i] forState:0];
        [btn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor dc_colorWithHexString:DC_BtnColor].CGColor;
        [self.gxDetailview addSubview:btn];
    }
    [self.gxDetailview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneview.bottom);
        make.left.equalTo(gxLB.right).offset(10);
        make.height.equalTo(h+40);
        make.right.equalTo(view.right).offset(-15);
    }];
    
    UIView *gxView = [[UIView alloc] init];
    gxView.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self.scrollView addSubview:gxView];
    [gxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gxLB.bottom);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
        make.bottom.equalTo(self.scrollView).offset(20);
    }];
    
}

- (void)gxMethod:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [self.selectGxArray addObject:btn.currentTitle];
    }else{
        btn.backgroundColor = [UIColor whiteColor];
        [self.selectGxArray removeObject:btn.currentTitle];
    }
}

- (void)genderMethod:(UIButton *)btn{
    self.genderNanBtn.selected = btn == self.genderNanBtn;
    self.genderNvBtn.selected = btn == self.genderNvBtn;
}

- (void)birthdyBtnMethod{
    [self.pickerDate show];
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSString *time = [NSString stringWithFormat:@"%zd%02zd%02zd",year,month,day];
    self.birthdayTF.text = time;
}

-(NSMutableArray *)selectGxArray{
    if (!_selectGxArray) {
        _selectGxArray = [[NSMutableArray alloc] init];
    }
    return _selectGxArray;
}

-(STPickerDate *)pickerDate{
    if (!_pickerDate) {
        _pickerDate = [[STPickerDate alloc] init];
    }
    return _pickerDate;
}

- (void)addBtnMethod{
    
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
