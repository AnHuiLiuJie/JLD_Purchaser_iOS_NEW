//
//  GLPEtpEventInvitationVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/22.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPHomeViewController_Block)(NSError *error);//_Nullable _Nonnull



@interface GLPEtpEventInvitationVC : DCBasicViewController

@property (nonatomic,strong) GLPHomeViewController_Block mytestBlock;
//@property(nonatomic,copy) NSString *aString;
//- (NSString *)mmymethodWithString:(NSString *_Nullable)uuString;

@end

NS_ASSUME_NONNULL_END
