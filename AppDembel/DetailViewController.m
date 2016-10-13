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
#import "UIView+DCAnimationKit.h"

@interface DetailViewController () <VKSdkUIDelegate, AppodealInterstitialDelegate>
@property (nonatomic, strong) UIView* view1;

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
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(40, 165, 200, 100)];
    self.view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.view1];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(closeInfo)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 20);
    [self.view1 addSubview:button];
    [self.view1 expandIntoView:self.view finished:NULL];
}

- (void) closeInfo {
    [self.view1 drop:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view!=self.view1){
        [self.view1 drop:NULL];
    }
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
   _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.infoBTN];
    for (UIView* view in _labelArray) {
        [self hide:view];
        view.frame = CGRectMake(-200, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
}
- (void) setAnimationForCountDown {
    _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.infoBTN];
    [UIView mt_animateWithViews:_labelArray duration:1.5 timingFunction:kMTEaseOutBounce animations:^{
                         for (UIView* view in _labelArray) {
                             [self show:view];
                             view.center = CGPointMake(self.view.frame.size.width / 2, view.center.y);
                         }
                     }];
}
- (void) setAnimationForProgressBar {
    _labelArray = @[self.nameLabel, self.dateLabel, self.demobilizationDateLabel, self.infoBTN];
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
