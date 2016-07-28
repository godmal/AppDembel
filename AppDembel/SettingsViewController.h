//
//  SettingsViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 22.07.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingsViewController : BaseViewController 

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@end
