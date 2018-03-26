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
#import <QuartzCore/QuartzCore.h>
#import "UIView+Blur.h"

@interface DetailViewController () <AppodealInterstitialDelegate>
@property (nonatomic, strong) UIView* popView;
@end

@implementation DetailViewController {
    Person* _person;
    NSDictionary* _rightLabelData;
    NSDictionary* _leftLabelData;
    NSArray* _labelArray;
    UIView *blurEffectView;
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
            [UIView animateWithDuration:1.3f animations:^{
                self.progressBarPercent.value = [_person calculatePercentProgress];
            }];
        }
}

- (void)interstitialDidDismiss {
    if ([DateUtils isAfterNow:_person.date]) {
        [self setAnimationForCountDown];
    } else {
        [self setAnimationForProgressBar];
        [UIView animateWithDuration:1.3f animations:^{
            self.progressBarPercent.value = [_person calculatePercentProgress] ;
        }];
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
    
    [self createBlurEffect];
    [self.popView drop:NULL];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    imageView.image = [UIImage imageNamed:@"250.png"];
    
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    self.popView.center = CGPointMake(self.view.frame.size.width  / 2,
                                     self.view.frame.size.height / 2);
    self.popView.backgroundColor = [UIColor whiteColor];
    
    [self configureUILabels];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(closeInfo) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Закрыть" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = CGRectMake(0, 0, self.popView.frame.size.width / 3, 35);
    button.center = CGPointMake(self.popView.frame.size.width / 2,
                                self.popView.frame.size.height - 20);
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
//    button.layer.borderWidth = 1.0;
    [self.popView addSubview:button];
    [self.popView addSubview:imageView];
    [self.popView expandIntoView:self.view finished:NULL];
    [self.popView sendSubviewToBack:imageView];
}

- (void) closeInfo {
    blurEffectView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 animations:^{
        blurEffectView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [blurEffectView removeFromSuperview];
    }];
    [self.popView drop:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    UITouch *touch = [touches anyObject];
    if(touch.view!=self.popView){
        [self closeInfo];
    }
}
#pragma mark configuration

- (void) setBeforeArmyMode {
    self.infoLabel.text = @"Осталось до службы:";
    NSArray* array = @[self.rightLabel, self.leftLabel, self.progressBarPercent, self.lineView];
    for (UIView* view in array) {
        view.hidden = YES;
    }
    self.daysLeft.hidden = NO;
}
- (void) setInArmyMode {
    self.infoLabel.text = @"Детали службы";
    NSArray* array = @[self.rightLabel, self.leftLabel, self.progressBarPercent, self.lineView];
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
    [UIView animateWithDuration:0 animations:^{
        self.progressBarPercent.value = 0;
    }];
}
- (void) setPersonDataText {
    self.nameLabel.text = _person.name;
}
- (void) configureDetailsView {
    _rightLabelData = [DateUtils getUnitsBetween:[DateUtils now] and:_person.endDate];
    _leftLabelData = [DateUtils getUnitsBetween:_person.date and:[DateUtils now]];
}
-(void) configureUILabels {
    UILabel* startDate = [[UILabel alloc] initWithFrame:CGRectMake(13, 8, 110, 150)];
    startDate.text = [NSString stringWithFormat:@"Начало службы \n %@", [DateUtils convertDateToString:_person.date]];
    UILabel* endDate = [[UILabel alloc] initWithFrame:CGRectMake(127, 8, 110, 150)];
    endDate.text = [NSString stringWithFormat:@"Конец службы \n %@", [DateUtils convertDateToString: _person.endDate]];
    NSArray* array = @[startDate, endDate];
    for (UILabel *label in array) {
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self.popView addSubview:label];
//        label.layer.borderColor = [UIColor whiteColor].CGColor;
//        label.layer.borderWidth = 1.0;
    }
}
- (void)interstitialDidFailToLoadAd {
    NSLog(@"interstitial failed to load");
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

- (void) createBlurEffect {
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.view.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        blurEffectView.transform = CGAffineTransformMakeScale(0, 0);
//        [UIView animateWithDuration:0.15 animations:^{
//            blurEffectView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        } completion:^(BOOL finished) {
//        }];
//        [self.view addSubview:blurEffectView];
//    } else {
//        self.view.backgroundColor = [UIColor blackColor];
//    }
    
    blurEffectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [blurEffectView enableBlur:YES];
    [blurEffectView setBlurTintColor:[UIColor clearColor]];
    [blurEffectView setBlurTintColorIntensity:0.1f];
    blurEffectView.blurStyle = UIViewBlurExtraLightStyle;
    blurEffectView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.15 animations:^{
                    blurEffectView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    
                }];
    [self.view addSubview:blurEffectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - position&animation

- (void) setInitialPosition {
   _labelArray = @[self.nameLabel, self.infoBackView];
    for (UIView* view in _labelArray) {
        [self hide:view];
        view.frame = CGRectMake(-200, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
}
- (void) setAnimationForCountDown {
    _labelArray = @[self.nameLabel, self.infoBackView];
    [UIView mt_animateWithViews:_labelArray duration:1.5 timingFunction:kMTEaseOutBounce animations:^{
                         for (UIView* view in _labelArray) {
                             [self show:view];
                             view.center = CGPointMake(self.view.frame.size.width / 2, view.center.y);
                         }
                     }];
}
- (void) setAnimationForProgressBar {
    _labelArray = @[self.nameLabel, self.infoBackView];
    [UIView mt_animateWithViews:_labelArray duration:1.5 timingFunction:kMTEaseOutBounce animations:^{
                         for (UIView* view in _labelArray) {
                             [self show:view];
                             view.center = CGPointMake(self.view.frame.size.width / 4.3, view.center.y);
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

//#pragma mark vkSdk methods
//
//- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
//    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
//    [vc presentIn:self.navigationController.topViewController];
//}
//- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
//    if (result.token) {
//    } else if (result.error) {
//        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//    }
//}
//- (void)vkSdkUserAuthorizationFailed {
//    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewControllerCancelled" object:nil];
//    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
//}

@end
