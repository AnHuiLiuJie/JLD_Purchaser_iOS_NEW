//
//  EtpEntrepreneurPosterCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EtpEntrepreneurPosterCell : UITableViewCell

@property (nonatomic, copy) void(^etpEntrepreneurPosterCellClick_block)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
