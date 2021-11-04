//
//  DHMessageListCell.h
//  DCProject
//
//  Created by Apple on 2019/9/26.
//  Copyright © 2019年 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHMessageListCell : UITableViewCell

+(DHMessageListCell *)cellShareInstnce:(UITableView *)tableView with:(NSIndexPath *)indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *messageIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@property (weak, nonatomic) IBOutlet UILabel *msgLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgWidthLB;



/** @brief 会话对象 */
@property (strong, nonatomic) id<IConversationModel> model;

@end

NS_ASSUME_NONNULL_END
