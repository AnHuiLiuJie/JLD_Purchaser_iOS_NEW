//
//  GLPActivityAreaCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/11.
//

#import "GLPActivityAreaCell.h"
#import "GLPActivityAreaListCell.h"
@interface GLPActivityAreaCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

static CGFloat cell_spacing_x = 10;
static CGFloat cell_spacing_y = 5;
static NSString *const GLPActivityAreaListCellID = @"GLPActivityAreaListCell";

@implementation GLPActivityAreaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];
    
    _topImageView = [[UIImageView alloc] init];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.image = [[DCPlaceholderTool shareTool] dc_placeholderImage];
    [_bgView addSubview:_topImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"GLPActivityAreaListCell" bundle:nil] forCellReuseIdentifier:GLPActivityAreaListCellID];
    _tableView.scrollEnabled = NO;
    [_bgView addSubview:_tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
    }];
    
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top);
        make.left.right.equalTo(self.bgView);
        make.height.equalTo(AreaListHeader_H);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.bottom);
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView.bottom).priorityHigh();
    }];
    
}


#pragma mark - set

- (void)setModel:(ActivityAreaModel *)model{
    _model = model;
    
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_model.actImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    [self.tableView reloadData];
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.goodsVO.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AreaListCell_H;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPActivityAreaListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPActivityAreaListCellID];
    if (cell==nil){
        cell = [[GLPActivityAreaListCell alloc] init];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ActivityAreaGoodsVOModel *model = self.model.goodsVO[indexPath.section];
    cell.model = model;
    WEAKSELF;
    cell.GLPActivityAreaListCell_block = ^(NSString * _Nonnull goodsId) {
        !weakSelf.GLPActivityAreaCell_block ? : weakSelf.GLPActivityAreaCell_block(goodsId);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
