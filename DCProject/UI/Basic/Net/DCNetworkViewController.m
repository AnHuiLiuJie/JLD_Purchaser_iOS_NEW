//
//  DCNetworkViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/7/9.
//

#import "DCNetworkViewController.h"
@interface DCNetworkViewController ()


@property (nonatomic, strong) NetWorkManagerView *netWorkview;//网络检测view

@end

@implementation DCNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.netWorkview.frame = [[[UIApplication sharedApplication] windows] objectAtIndex:0].bounds;
    [self.view addSubview:self.netWorkview];}

- (NetWorkManagerView *)netWorkview{
    
    if (!_netWorkview) {
        _netWorkview = [[NetWorkManagerView alloc] init];
        WEAKSELF;
        _netWorkview.clickNewWorkBtnAction_Block = ^(NSInteger index) {
            if (index == 3) {
//                LookOverNetViewController *vc = [[LookOverNetViewController alloc] init];
//                UIViewController* viewController = [weakSelf currentViewController];
//                [viewController.navigationController pushViewController:vc animated:NO];
                
            }else if (index == 1){
                [weakSelf refreshLoadDataBaseIndex:1];
            }
        };
    }
    
    return _netWorkview;
}

- (void)refreshLoadDataBaseIndex:(NSInteger)click_index
{
    if (click_index == 1) {
        [SVProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            //[self makeMyToast:@"加载失败,请检查网络设置" duration:Toast_During position:CSToastPositionBottom bColor:nil];
        });
    }else{
        //[self makeMyToast:@"网络已恢复" duration:Toast_During position:CSToastPositionBottom bColor:nil];
    }
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
