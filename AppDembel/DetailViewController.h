//
//  DetailViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBCircularProgressBarView.h"
#import "HMSideMenu.h"
#import "THLabel.h"
#import <MGInstagram/MGInstagram.h>

@interface DetailViewController : BaseViewController <VKSdkDelegate, UIDocumentInteractionControllerDelegate>

@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) BOOL qwerty;
@property (nonatomic, strong) HMSideMenu *sideMenu;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *demobilizationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeft;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarPercent;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet THLabel *leftDaysLabel;
@property (weak, nonatomic) IBOutlet THLabel *servedDaysLabel;
@property (nonatomic, strong) MGInstagram *instagram;
@end
