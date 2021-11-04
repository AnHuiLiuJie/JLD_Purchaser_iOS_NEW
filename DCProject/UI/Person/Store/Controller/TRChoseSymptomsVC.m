//
//  TRChoseRandVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRChoseSymptomsVC.h"
#import "ChoseModel.h"
#import "TRChoseCell.h"
@interface TRChoseSymptomsVC()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *indexDataSource;/**<索引数据源*/
@property(nonatomic,strong) NSMutableArray *selectArray;
@end

@implementation TRChoseSymptomsVC

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
    
    [self.allDataSource addObjectsFromArray:self.dataArray];
    [self.selectArray addObjectsFromArray:self.choseArray];
    [self.tableView reloadData];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (IBAction)resetClick:(id)sender {
    [self.selectArray removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)comfireClick:(id)sender {
//      [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (self.symptomsblock) {
        self.symptomsblock(self.selectArray);
    }
  
}

- (IBAction)dissClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
}
//#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [_allDataSource count];
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRChoseCell"];
    if (cell==nil)
    {
        cell = [[TRChoseCell alloc] init];
    }
    NSString *str=self.allDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageV.image = [UIImage imageNamed:@"xuanzezhong"];
    cell.Lab.text = [NSString stringWithFormat:@"%@",str];
    if ([self.selectArray containsObject:[NSString stringWithFormat:@"%@",str]])
    {
        cell.imageV.hidden = NO;
    }
    else{
        cell.imageV.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 0.01;
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
   NSString *str=self.allDataSource[indexPath.row];
    if ([self.selectArray containsObject:[NSString stringWithFormat:@"%@",str]])
    {
        [self.selectArray removeObject:[NSString stringWithFormat:@"%@",str]];
    }
    else{
        [self.selectArray addObject:[NSString stringWithFormat:@"%@",str]];
    }
    [self.tableView reloadData];
}

@end
