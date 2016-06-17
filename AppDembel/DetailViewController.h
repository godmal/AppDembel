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


@interface DetailViewController : BaseViewController <VKSdkDelegate>

@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) BOOL qwerty;
@property (nonatomic, strong) HMSideMenu *sideMenu;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *demobilizationDateLabel;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *daysLeft;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarPercent;
@property (weak, nonatomic) IBOutlet UIButton *changeViewButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)changeView:(id)sender;

@end
