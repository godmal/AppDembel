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
#import "HMSideMenu.h"
#import <AVFoundation/AVFoundation.h>
#import <ClusterPrePermissions/ClusterPrePermissions.h>
#import "UIView+MTAnimation.h"
#import <QuartzCore/QuartzCore.h>

static NSArray *SCOPE = nil;

@interface DetailViewController () <VKSdkUIDelegate>

@end

@implementation DetailViewController {
    Person* _person;
    NSDictionary* _rightLabelData;
    NSDictionary* _leftLabelData;
}
#pragma mark lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setInitialPosition];
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[[self setInstaItem], [self setVkItem]]];
    [self.sideMenu setItemSpacing:10.0f];
    
    SCOPE = @[VK_PER_WALL, VK_PER_PHOTOS, VK_PER_NOHTTPS];
    [[VKSdk initializeWithAppId:@"5477600"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            _qwerty = YES;
        } else if (error) {
            _qwerty = NO;
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetViewParameters)
                                                 name:@"EditViewControllerCancelled"
                                               object:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
 }

- (void) viewWillAppear:(BOOL)animated {
    _person = [self.model.people objectAtIndex:self.index];
    //[Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
    [DateUtils configureCountDownWithDate:_person.date];
    _rightLabelData = [DateUtils getUnitsBetween:[DateUtils now] and:_person.endDate];
    _leftLabelData = [DateUtils getUnitsBetween:_person.date and:[DateUtils now]];
    [self setLabelsText];
    if ([DateUtils isAfterNow:_person.date]) {
        self.infoLabel.text = @"Осталось до службы:";
        [self show: self.daysLeft andHide:self.progressBarPercent];
        self.detailsView.hidden = YES;
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    } else {
        self.infoLabel.text = @"Детали службы";
        [self show: self.progressBarPercent andHide:self.daysLeft];
        self.detailsView.hidden = NO;
    }
}
- (void) viewDidAppear:(BOOL)animated {
    [self createPermission];
    if ([DateUtils isAfterNow:_person.date]) {
        [self setAnimationForCountDown];
    } else {
        [self setAnimationForProgressBar];
        [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1];
    }
}
- (void) showSideMenu {
    [self.sideMenu open];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* segueName = segue.identifier;
    [segueName isEqualToString:@"editSegue"];
    EditViewController* editView = (EditViewController*) [segue destinationViewController];
    editView.index = self.index;
    [self.sideMenu removeFromSuperview];
}

#pragma mark configuration

- (void) setLabelsText {
    self.nameLabel.text = _person.name;
    self.dateLabel.text = [DateUtils convertDateToString:_person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString: _person.endDate];
    self.rightLabel.text = [NSString stringWithFormat:@"месяцы - %@  недели - %@ дни - %@",
                            [_rightLabelData objectForKey:@"months"],
                            [_rightLabelData objectForKey:@"weeks"],
                            [_rightLabelData objectForKey:@"days"]];
    self.leftLabel.text = [NSString stringWithFormat:@"месяцы - %@  недели - %@ дни - %@",
                           [_leftLabelData objectForKey:@"months"],
                           [_leftLabelData objectForKey:@"weeks"],
                           [_leftLabelData objectForKey:@"days"]];
}

- (void) resetViewParameters {
    [self.progressBarPercent setValue:0 animateWithDuration:0];
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

- (void) createPermission {
    ClusterPrePermissions *permissions = [ClusterPrePermissions sharedPermissions];
    [permissions showPhotoPermissionsWithTitle:@"Разрешить доступ к фото?"
                                       message:@"Без доступа не сможешь поделиться результатами с друзьями."
                               denyButtonTitle:@"Не хочу делиться"
                              grantButtonTitle:@"Разрешить!"
                             completionHandler:^(BOOL hasPermission,
                                                 ClusterDialogResult userDialogResult,
                                                 ClusterDialogResult systemDialogResult) {
                                 if (hasPermission) {
                                     [self.view addSubview:self.sideMenu];
                                     [self performSelector:@selector(showSideMenu) withObject:nil afterDelay:2];
                                 } else {
                                     [self.sideMenu removeFromSuperview];
                                 }
                             }];
}
#pragma mark - position&animation

- (void) setInitialPosition {
    self.nameLabel.frame = CGRectMake(-300, self.nameLabel.frame.origin.y +10, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    self.dateLabel.frame = CGRectMake(-300, self.dateLabel.frame.origin.y +10, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
    self.demobilizationDateLabel.frame = CGRectMake(-300, self.demobilizationDateLabel.frame.origin.y +10, self.demobilizationDateLabel.frame.size.width, self.demobilizationDateLabel.frame.size.height);
}
- (void) setAnimationForCountDown {
    [UIView mt_animateWithViews:@[self.nameLabel, self.dateLabel, self.demobilizationDateLabel]
                       duration:1.5
                 timingFunction:kMTEaseOutBounce
                     animations:^{
                         self.nameLabel.center = CGPointMake(self.view.frame.size.width  / 2,
                                                             self.nameLabel.frame.origin.y);
                         self.dateLabel.center = CGPointMake(self.view.frame.size.width  / 2,
                                                             self.dateLabel.frame.origin.y);
                         self.demobilizationDateLabel.center = CGPointMake(self.view.frame.size.width  / 2,
                                                                           self.demobilizationDateLabel.frame.origin.y);
                     }];
}
- (void) setAnimationForProgressBar {
    [UIView mt_animateWithViews:@[self.nameLabel, self.dateLabel, self.demobilizationDateLabel]
                       duration:1.5
                 timingFunction:kMTEaseOutBounce
                     animations:^{
                         self.nameLabel.center = CGPointMake(self.view.frame.size.width  / 4.4,
                                                             self.nameLabel.frame.origin.y);
                         self.dateLabel.center = CGPointMake(self.view.frame.size.width  / 4.4,
                                                             self.dateLabel.frame.origin.y);
                         self.demobilizationDateLabel.center = CGPointMake(self.view.frame.size.width  / 4.4,
                                                                           self.demobilizationDateLabel.frame.origin.y);
                     }];
}
- (HMSideMenuItem*) setInstaItem {
    HMSideMenuItem *instaItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(50, 50) action:^{
        if ([self isInstagramInstalled]) {
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
                [self makeScreenshot];
                NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                    [[UIApplication sharedApplication] openURL:instagramURL];
                }
            }];
        } else {
            [self createInstagramAlert];
        }
    }];
    UIImageView *instaIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [instaIcon setImage:[UIImage imageNamed:@"_insta"]];
    [instaItem addSubview:instaIcon];
    return instaItem;
}
- (HMSideMenuItem*) setVkItem {
    HMSideMenuItem *vkItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(50 , 50) action:^{
        if (_qwerty) {
            UIImage* screenshot = [self makeScreenshot];
            VKShareDialogController *shareDialog = [VKShareDialogController new];
            shareDialog.text = @"Отдаю долг Родине с приложением ПораДомой";
            shareDialog.uploadImages = @[ [VKUploadImage uploadImageWithImage:screenshot andParams:[VKImageParameters jpegImageWithQuality:1.0]]];
            [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [self presentViewController:shareDialog animated:YES completion:nil];
        } else
            [VKSdk authorize:SCOPE];
    }];
    UIImageView *vkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [vkIcon setImage:[UIImage imageNamed:@"_vk"]];
    [vkItem addSubview:vkIcon];
    return vkItem;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end