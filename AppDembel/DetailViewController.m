//
//  DetailViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "DetailViewController.h"
#import "DateUtils.h"
#import "People.h"
#import "EditViewController.h"
#import "Person.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+MTAnimation.h"


@import AMPopTip;

@interface DetailViewController () <VKSdkUIDelegate, AppodealInterstitialDelegate>
@property (nonatomic, strong) AMPopTip *popTip;

@end

@implementation DetailViewController {
    Person* _person;
    NSDictionary* _rightLabelData;
    NSDictionary* _leftLabelData;
    NSArray* _labelArray;
}

#pragma mark main methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [Appodeal setInterstitialDelegate:self];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.imageView.image = [self loadImage];
    [self setInitialPosition];
    [self observeEditViewStatus];
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];


}

- (void) viewWillAppear:(BOOL)animated {
    [Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
    _person = [self.model.people objectAtIndex:self.index];
    (![DateUtils isAfterNow:_person.date]) ? [self setInArmyMode] : [self setBeforeArmyMode];
    [self setPersonDataText];
    [self setLabelsText];
}

- (void) viewDidAppear:(BOOL)animated {
        if ([DateUtils isAfterNow:_person.date]) {
            [self setAnimationForCountDown];
        } else {
            [self setAnimationForProgressBar];
            [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1.3];
        }
}

- (void)interstitialDidDismiss {
    if ([DateUtils isAfterNow:_person.date]) {
        [self setAnimationForCountDown];
    } else {
        [self setAnimationForProgressBar];
        [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1.3];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        EditViewController* editView = (EditViewController*) [segue destinationViewController];
        editView.index = self.index;
    }
}

- (IBAction)instaShare:(id)sender {
    [MGInstagram isAppInstalled] ? [self manageInstagramShare] : [self createInstagramAlert];
    
}

- (IBAction)infoButton:(UIButton *)sender {
    self.popTip = [AMPopTip popTip];
//    [self.popTip showText:[NSString stringWithFormat:@"Дата призыва: %@ \n Дата дембеля: %@ ", [DateUtils convertDateToString:_person.date], [DateUtils convertDateToString: _person.endDate]] direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:self.view1.frame];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height / 3)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.numberOfLines = 0;
    label.text = @"Showing a custom view!";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [customView addSubview:label];
    self.popTip.popoverColor = [UIColor colorWithRed:0.95 green:0.65 blue:0.21 alpha:1];
    [self.popTip showCustomView:customView direction:AMPopTipDirectionRight inView:self.view fromFrame:sender.frame];

}
#pragma mark configuration

- (void) setBeforeArmyMode {
    self.infoLabel.text = @"Осталось до службы:";
    NSArray* array = @[self.rightLabel, self.leftLabel, self.progressBarPercent];
    for (UIView* view in array) {
        view.hidden = YES;
    }
    self.daysLeft.hidden = NO;
}
- (void) setInArmyMode {
    self.infoLabel.text = @"Детали службы";
    NSArray* array = @[self.rightLabel, self.leftLabel, self.progressBarPercent];
    for (UIView* view in array) {
        view.hidden = NO;
    }
    self.daysLeft.hidden = YES;
    [self configureDetailsView];
}
- (void) setLabelsText {
    self.rightLabel.text = [NSString stringWithFormat:@"Осталось: \n\n\n %i дней", (int)[_person calculateLeftDays]];
    self.leftLabel.text = [NSString stringWithFormat:@"Отслужил: \n\n\n %i дней", (int)[_person calculateProgressDays]];
}
- (void) observeEditViewStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetViewParameters)
                                                 name:@"EditViewControllerCancelled"
                                               object:nil];
}
- (void) resetViewParameters {
    [self.progressBarPercent setValue:0 animateWithDuration:0];
}
- (void) setPersonDataText {
    self.nameLabel.text = _person.name;
    self.dateLabel.text = [DateUtils convertDateToString:_person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString: _person.endDate];
}
- (void) configureDetailsView {
    _rightLabelData = [DateUtils getUnitsBetween:[DateUtils now] and:_person.endDate];
    _leftLabelData = [DateUtils getUnitsBetween:_person.date and:[DateUtils now]];
}
- (void)updateCounter:(NSTimer *)tmr {
    NSTimeInterval timer = [[DateUtils configureCountDownWithDate:_person.date] timeIntervalSinceNow];
    int days = timer / (60 * 60 * 24);
    timer -= days * (60 * 60 * 24);
    int hours = timer / (60 * 60);
    timer -= hours * (60 * 60);
    int minutes = timer / 60;
    timer -= minutes * 60;
    int seconds = timer;
    self.daysLeft.text = [NSString stringWithFormat:@"Дней:  %02d\nЧасов:  %02d\nМинут:  %02d\nСекунд:  %02d", days, hours, minutes, seconds];
    if (days + hours + minutes + seconds <= 0) {
        [tmr invalidate];
        if (!self.daysLeft.hidden) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - position&animation

- (void) setInitialPosition {
   _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.view1];
    for (UIView* view in _labelArray) {
        [self hide:view];
        view.frame = CGRectMake(-200, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
}
- (void) setAnimationForCountDown {
    _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.view1];
    [UIView mt_animateWithViews:_labelArray duration:1.5 timingFunction:kMTEaseOutBounce animations:^{
                         for (UIView* view in _labelArray) {
                             [self show:view];
                             view.center = CGPointMake(self.view.frame.size.width / 2, view.center.y);
                         }
                     }];
}
- (void) setAnimationForProgressBar {
    _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.view1];
    [UIView mt_animateWithViews:_labelArray duration:1.5 timingFunction:kMTEaseOutBounce animations:^{
                         for (UIView* view in _labelArray) {
                             [self show:view];
                             view.center = CGPointMake(self.view.frame.size.width / 4.4, view.center.y);
                            }
                     }];
}

- (void) manageInstagramShare {
    AudioServicesPlaySystemSound(1108);
    UIView* screenshotView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    screenshotView.alpha = 1;
    [UIView animateWithDuration:1.5f animations:^{
        screenshotView.backgroundColor = [UIColor whiteColor];
        screenshotView.alpha = 0;
        [currentWindow addSubview:screenshotView];
    } completion:^(BOOL finished) {
        [screenshotView removeFromSuperview];
        self.instagram = [[MGInstagram alloc] init];
        [self.instagram postImage:[self makeScreenshot] inView:self.view];
         }];
}

#pragma mark vkSdk methods

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}
- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}
- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewControllerCancelled" object:nil];
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

@end
