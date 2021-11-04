//
//  TRChoseRandVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRChoseRandVC.h"
#import "ChoseModel.h"
#import "TRChoseCell.h"
@interface TRChoseRandVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *indexDataSource;/**<索引数据源*/
@property(nonatomic,strong) NSMutableArray *selectArray;
@end

@implementation TRChoseRandVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.heightCons.constant = kScreenH;
    self.widthCons.constant =((kScreenW - 95) - 16*2 - 30 )/2;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 20;
    self.comfireBtn.layer.masksToBounds = YES;
    self.comfireBtn.layer.cornerRadius = 20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TRChoseCell" bundle:nil] forCellReuseIdentifier:@"TRChoseCell"];
    self.allDataSource = [NSMutableArray arrayWithCapacity:0];
    self.indexDataSource = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.dataArray.count; i++)
    {
        NSString *str=self.dataArray[i];
        NSDictionary *dic = @{@"choseName":str};
        ChoseModel *model = [[ChoseModel alloc]initWithDic:dic];
        [array addObject:model];
    }
    self.allDataSource = [self sortObjectsAccordingToInitialWith:array];
    [self.selectArray addObjectsFromArray:self.choseArray];
    [self.tableView reloadData];
}

- (IBAction)resetClick:(id)sender {
    [self.selectArray removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)comfireClick:(id)sender {
//     [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (self.randblock) {
        self.randblock(self.selectArray);
    }
    
}

- (IBAction)dissClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
}
//#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
        return _indexDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        return [_allDataSource[section] count];
   
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
        return _indexDataSource[section];
        //return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"][section];
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
   
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRChoseCell"];
    if (cell==nil)
    {
        cell = [[TRChoseCell alloc] init];
    }
    ChoseModel *model = self.allDataSource[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageV.image = [UIImage imageNamed:@"xuanzezhong"];
    cell.Lab.text = [NSString stringWithFormat:@"%@",model.choseName];
    if ([self.selectArray containsObject:[NSString stringWithFormat:@"%@",model.choseName]])
    {
        cell.imageV.hidden = NO;
    }
    else{
        cell.imageV.hidden = YES;
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray *arr = self.allDataSource[index];
    if (arr.count==0)
    {
        return  index;
    }
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   if ([self.indexDataSource[section] isEqualToString:@""])
        {
            return 0.01;
        }
        else{
            return 25;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoseModel *model = self.allDataSource[indexPath.section][indexPath.row];
    
    if ([self.selectArray containsObject:[NSString stringWithFormat:@"%@",model.choseName]])
    {
        [self.selectArray removeObject:[NSString stringWithFormat:@"%@",model.choseName]];
    }
    else{
        [self.selectArray addObject:[NSString stringWithFormat:@"%@",model.choseName]];
    }
    [self.tableView reloadData];
}
// 按首字母分组排序数组
-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (ChoseModel *personModel in arr) {
       
            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
            NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(choseName)];
            //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
            NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
            [sectionNames addObject:personModel];
       
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(choseName)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    NSArray *indexarray=@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
            [self.indexDataSource addObject:indexarray[index]];
        }
        else{
            [finalArr addObject:@[]];
            [self.indexDataSource addObject:@""];
        }
    }
    return finalArr;
    //[self.indexDataSource addObjectsFromArray:indexarray];
    //return newSectionsArray;
}
@end
