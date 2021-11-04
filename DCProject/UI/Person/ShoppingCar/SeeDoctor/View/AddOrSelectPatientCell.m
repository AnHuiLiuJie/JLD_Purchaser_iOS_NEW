//
//  AddOrSelectPatientCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "AddOrSelectPatientCell.h"

@interface AddOrSelectPatientCell ()
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIScrollView *scrollBgView;

@property (nonatomic, strong) UIView *bgView2;


@end

@implementation AddOrSelectPatientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI{
    _itemW = 150;
    _itemH = 102;
    _spacing = 15;
    
    self.bgView1.hidden = NO;
    self.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - set
-(void)setDrugId:(NSString *)drugId{
    _drugId = drugId;
    
    __block NSInteger index = 0;
    __block NSInteger defindex = 0;
    [_persList enumerateObjectsUsingBlock:^(MedicalPersListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.drugId isEqualToString:model.drugId]) {
            //model.isSelected = YES;
            index = idx;
        }
        if ([model.isDefault isEqualToString:@"1"]) {
            defindex = idx;
        }
    }];
    if (index == 0) {
        index = defindex;
    }
    
    for (UIView *indexV in self.scrollBgView.subviews) {
        if ([indexV isKindOfClass:[MedicalPersListView class]]) {
            if (index  == indexV.tag) {
                ((MedicalPersListView *)indexV).model.isSelected = YES;
                ((MedicalPersListView *)indexV).statusBtn.selected = YES;
                ((MedicalPersListView *)indexV).bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
            }else{
                ((MedicalPersListView *)indexV).model.isSelected = NO;
                ((MedicalPersListView *)indexV).statusBtn.selected = NO;
                ((MedicalPersListView *)indexV).bgView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)setPersList:(NSArray *)persList{
    _persList = persList;
    if (_persList.count == 0) {
        _bgView2.hidden = NO;
        _scrollBgView.hidden = YES;
        self.bgView1.hidden = NO;
    }else{
        _bgView1.hidden = YES;
        self.scrollBgView.hidden = NO;
        self.contentView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];

        if (_persList.count > 0) {
            for (int i=0; i<_persList.count; i++) {
                MedicalPersListModel *model = _persList[i];
                MedicalPersListView *view = [[MedicalPersListView alloc] init];
                [self.scrollBgView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.scrollBgView).offset((_itemW+_spacing)*i);
                    make.centerY.equalTo(self.scrollBgView.centerY);
                    make.height.equalTo(_itemH);
                    make.width.equalTo(_itemW);
                }];
                
                if ([model.isDefault isEqualToString:@"1"]) {
                    model.isSelected = YES;
                    view.bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
                }

                view.model = model;
                WEAKSELF;
                view.MedicalPersListView_block = ^(NSInteger index) {
                    !weakSelf.AddOrSelectPatientCell_editBlock ? : weakSelf.AddOrSelectPatientCell_editBlock(model);
                };
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                view.tag = i;
                [view addGestureRecognizer:tap3];
            }
        }
        
        self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_persList.count, _itemH);
    }
    
    [self layoutIfNeeded];

}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView * view = recognizer.view;
    for (UIView *indexV in self.scrollBgView.subviews) {
        if ([indexV isKindOfClass:[MedicalPersListView class]]) {
            if (view.tag  == indexV.tag) {
                ((MedicalPersListView *)indexV).model.isSelected = YES;
                ((MedicalPersListView *)indexV).statusBtn.selected = YES;
                ((MedicalPersListView *)indexV).bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
                !_AddOrSelectPatientCell_selectedBlock ? :  _AddOrSelectPatientCell_selectedBlock(((MedicalPersListView *)indexV).model);
            }else{
                ((MedicalPersListView *)indexV).model.isSelected = NO;
                ((MedicalPersListView *)indexV).statusBtn.selected = NO;
                ((MedicalPersListView *)indexV).bgView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.scrollBgView layoutIfNeeded];
//    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_persList.count == 0) {
        [_bgView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(70).priorityHigh();//将自己定的高度自适应的约束调高优先级即可。
        }];
    }else{

        [_scrollBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_itemH).priorityHigh();
        }];
        
    }
}

#pragma mark  Lazy
- (UIView *)bgView1{
    if (!_bgView1) {
        _bgView1.hidden = NO;
        _bgView1 = [[UIView alloc] init];
        _bgView1.backgroundColor = [UIColor dc_colorWithHexString:@"#DCFFFD"];
        
        UIImageView *iconImg = [[UIImageView alloc] init];
        [iconImg setImage:[UIImage imageNamed:@"dc_add_more"]];
        [_bgView1 addSubview:iconImg];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"新增用药人";
        titleLab.textColor = [UIColor dc_colorWithHexString:@"#00BEB3"];
        titleLab.font = [UIFont fontWithName:PFR size:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_bgView1 addSubview:titleLab];
        
        [self.contentView addSubview:_bgView1];
        
        [_bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
            make.height.equalTo(70).priorityHigh();//将自己定的高度自适应的约束调高优先级即可。mas_greaterThanOrEqualTo
        }];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView1).offset(15);
            make.centerY.equalTo(_bgView1);
        }];

        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleLab.left).offset(-5);
            make.centerY.equalTo(titleLab);
            make.size.equalTo(CGSizeMake(24, 24));
        }];
        
        [DCSpeedy dc_changeControlCircularWith:_bgView1 AndSetCornerRadius:5 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
        
        _bgView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTapAction:)];
        [_bgView1 addGestureRecognizer:tap3];

    }
    return _bgView1;
}

- (UIView *)bgView2{
    if (!_bgView2) {
        _bgView2 = [[UIView alloc] init];
        _bgView2.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"请选择用药人";
        titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        titleLab.font = [UIFont fontWithName:PFRMedium size:15];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_bgView2 addSubview:titleLab];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@" 添加 " forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont fontWithName:PFR size:12];
        [addBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView2 addSubview:addBtn];
        
        [self.contentView addSubview:_bgView2];
        [_bgView1 mas_remakeConstraints:^(MASConstraintMaker *make) {

        }];
        
        [_bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(10);
            make.right.equalTo(self.contentView.right).offset(-10);
            make.top.equalTo(self.contentView.top);
            make.height.equalTo(35);
        }];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView2.left).offset(0);
            make.centerY.equalTo(self.bgView2);
        }];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView2.right).offset(-15);
            make.centerY.equalTo(self.bgView2);
            make.size.equalTo(CGSizeMake(35, 20));
        }];
        
        [DCSpeedy dc_changeControlCircularWith:addBtn AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];

    }
    return _bgView2;
}

- (UIScrollView *)scrollBgView{
    if (!_scrollBgView) {


        _scrollBgView = [[UIScrollView alloc] init];
        [self.contentView addSubview:_scrollBgView];
        
        self.bgView2.hidden = NO;
        
        [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(35, 10, 0, -10));
            make.height.equalTo(_itemH).priorityHigh();//将自己定的高度自适应的约束调高优先级即可。mas_greaterThanOrEqualTo
        }];
        
        _scrollBgView.backgroundColor = [UIColor clearColor];
    }
    
    return _scrollBgView;
}

#pragma mark - 点击手势
- (void)addBtnAction:(UIButton *)btn{
    !_AddOrSelectPatientCell_AddBlock ? : _AddOrSelectPatientCell_AddBlock();
}

- (void)addTapAction:(id)sender{
    !_AddOrSelectPatientCell_AddBlock ? : _AddOrSelectPatientCell_AddBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


#pragma mark -************************* 用药人 *************************************
@interface MedicalPersListView ()


@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UILabel *relationLab;
@property (nonatomic, strong) UILabel *certificationLab;
@property (nonatomic, strong) UILabel *infoLab;


@end

@implementation MedicalPersListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    self.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    
    self.bgView.backgroundColor = [UIColor whiteColor];

    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        //make.height.equalTo(90).priorityHigh();//将自己定的高度自适应的约束调高优先级即可。mas_greaterThanOrEqualTo
    }];
    
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10;
    
    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:UIControlStateNormal];
    [_statusBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    [_bgView addSubview:_statusBtn];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nameLab.font = [UIFont fontWithName:PFRMedium size:16];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_nameLab];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"dc_info_edit"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_editBtn];
    
    _relationLab = [[UILabel alloc] init];
    _relationLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _relationLab.font = [UIFont fontWithName:PFR size:12];
    _relationLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_relationLab];

    _certificationLab = [[UILabel alloc] init];
    _certificationLab.textColor = [UIColor dc_colorWithHexString:@"#4CC268"];
    _certificationLab.font = [UIFont fontWithName:PFR size:12];
    _certificationLab.textAlignment = NSTextAlignmentLeft;
    _certificationLab.text = @"  已认证  ";
    [_bgView addSubview:_certificationLab];
    
    _infoLab = [[UILabel alloc] init];
    _infoLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _infoLab.font = [UIFont fontWithName:PFR size:12];
    _infoLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_infoLab];
    
}

#pragma mark - 编辑
- (void)editBtnAction:(UIButton *)btn{
    !_MedicalPersListView_block ? : _MedicalPersListView_block(1);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.top.equalTo(self.bgView.top).offset(10);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusBtn.right).offset(5);
        make.right.equalTo(self.editBtn.left).offset(0);
        make.centerY.equalTo(self.statusBtn.centerY);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-5);
        make.centerY.equalTo(self.statusBtn.centerY).offset(0);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_relationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.top.equalTo(self.statusBtn.bottom).offset(10);
        make.width.equalTo(40);
    }];
    
    [_certificationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.relationLab.right).offset(5);
        make.centerY.equalTo(self.relationLab.centerY).offset(0);
        make.height.equalTo(22);
    }];
    
    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.top.equalTo(self.relationLab.bottom).offset(15);
        make.right.equalTo(self.bgView.right).offset(0);
    }];
    
    [DCSpeedy dc_changeControlCircularWith:_certificationLab AndSetCornerRadius:11 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#4CC268"] canMasksToBounds:YES];
}


#pragma mark - setter
-(void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    _statusBtn.selected = _model.isSelected;
    
    _nameLab.text = _model.patientName;
    
    if ([model.relation isEqualToString:@"2"]) {
        _relationLab.text = @"  家属  ";
    }else if([model.relation isEqualToString:@"3"]){
        _relationLab.text = @"  亲戚  ";
    }else if([model.relation isEqualToString:@"3"]){
        _relationLab.text = @"  朋友  ";
    }else{
        _relationLab.text = @"  本人  ";
    }
    
    NSString *patientGender = [model.patientGender isEqualToString:@"1"] ? @"男" : @"女";
    NSString *patientTel = model.patientTel;
    if (_model.patientTel.length > 4) {
        patientTel = [NSString stringWithFormat:@"%@ **** %@",[_model.patientTel substringToIndex:3],[_model.patientTel substringFromIndex:_model.patientTel.length-4]];
    }
    
    _infoLab.text = [NSString stringWithFormat:@"%@  %@岁  %@",patientGender,model.patientAge,patientTel];
    
}

@end
