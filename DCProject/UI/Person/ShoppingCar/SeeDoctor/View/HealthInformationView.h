//
//  HealthInformationView.h
//  DCProject
//
//  Created by LiuMac on 2021/6/9.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthInformationView : UIView

@property (copy, nonatomic) void(^HealthInformationView_Block)(MedicalPersListModel *model);

@property (nonatomic, strong) MedicalPersListModel *model;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIView *historyInfoBgView;
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (weak, nonatomic) IBOutlet UILabel *infoNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *history_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *historyLine;

@property (weak, nonatomic) IBOutlet UIView *allergicBgView;
@property (weak, nonatomic) IBOutlet UITextView *allergicTextView;
@property (weak, nonatomic) IBOutlet UILabel *allergicNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allergic_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *allergicLine;

@property (weak, nonatomic) IBOutlet UIView *illnessBgView;
@property (weak, nonatomic) IBOutlet UITextView *illnessTextView;
@property (weak, nonatomic) IBOutlet UILabel *illnessNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *illness_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *illnessLine;

@property (weak, nonatomic) IBOutlet UIButton *historyNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *allergicNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *allergicYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *illnessNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *illnessYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *liverNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *liverYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *renalNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *renalYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *lactationNoBtn;
@property (weak, nonatomic) IBOutlet UIButton *lactationYesBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end

NS_ASSUME_NONNULL_END
