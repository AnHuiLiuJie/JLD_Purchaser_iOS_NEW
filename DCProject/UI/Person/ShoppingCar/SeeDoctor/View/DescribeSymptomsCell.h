//
//  DescribeSymptomsCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DescribeSymptomsCell : UITableViewCell

@property (strong, nonatomic) UITextView *historyTextView;

@property (copy, nonatomic) void(^DescribeSymptomsCell_block)(NSString *leaveMsg);
@property (copy, nonatomic) NSString *leaveMsg;

@end

NS_ASSUME_NONNULL_END
