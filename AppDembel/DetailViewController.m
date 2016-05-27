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

static NSArray *SCOPE = nil;

@interface DetailViewController () <VKSdkUIDelegate>

@end

@implementation DetailViewController {
    Person* _person;
    NSDate* _allDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.progressBar.hidden = YES;
    
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:@"5477600"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            NSLog(@"LOGIN");
            _qwerty = YES;
        } else if (error) {
            NSLog(@"DON'T LOGIN");
            _qwerty = NO;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetViewParameters)
                                                 name:@"EditViewControllerCancelled"
                                               object:nil];
    
    HMSideMenuItem *instaItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(40, 40) action:^{
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
            [[[UIAlertView alloc] initWithTitle:nil message:@"Instagram не установлен!" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil] show];
        }
    }];
    
    UIImageView *instaIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [instaIcon setImage:[UIImage imageNamed:@"instagram"]];
    [instaItem addSubview:instaIcon];
    
    HMSideMenuItem *vkItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(40, 40) action:^{
        if (_qwerty) {
            VKShareDialogController *shareDialog = [VKShareDialogController new];
            shareDialog.text = @"This post created created created created and made and post and delivered using #vksdk #ios";
            shareDialog.uploadImages = @[ [VKUploadImage uploadImageWithImage:[UIImage imageNamed:@"apple"] andParams:[VKImageParameters jpegImageWithQuality:1.0] ] ];
            [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [self presentViewController:shareDialog animated:YES completion:nil];
        } else
            [VKSdk authorize:SCOPE];
        }];
    
    UIImageView *vkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [vkIcon setImage:[UIImage imageNamed:@"vk"]];
    [vkItem addSubview:vkIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[instaItem, vkItem]];
    [self.sideMenu setItemSpacing:10.0f];
    [self.view addSubview:self.sideMenu];

}

-(void) viewWillAppear:(BOOL)animated {
    
    _person = [self.model.people objectAtIndex:self.index];
    NSDateFormatter *dateFormat = [DateUtils getFormatter];
    self.progressBar.maxValue = [DateUtils getDaysBetween:_person.date and:_person.endDate];
    
    NSString* dateString = [dateFormat stringFromDate:_person.date];
    NSDateFormatter *dateFormatTime = [DateUtils getFormatterWithTime];
    NSString* timeString = @" 00:00:00";
    NSString* all = [dateString stringByAppendingString:timeString];
    _allDate = [dateFormatTime dateFromString:all];
    
    self.nameLabel.text = _person.name;
    self.dateLabel.text = [DateUtils convertDateToString:_person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString: _person.endDate];
    
    if ([DateUtils isAfterNow:_person.date]) {
        self.changeViewButton.enabled= NO;
        [self show: self.daysLeft andHide:self.progressBarPercent];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    } else {
        [self show: self.progressBarPercent andHide:self.daysLeft];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(showSideMenu) withObject:nil afterDelay:2];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.progressBar.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.progressBarPercent.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
    }];
    if (![DateUtils isAfterNow:_person.date]) {
        [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1];
    }
}

- (void) showSideMenu {
    [self.sideMenu open];
}

-(void) resetViewParameters {
    [self.sideMenu removeFromSuperview];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.progressBar.transform = CGAffineTransformMakeScale(1, 1);
        self.progressBarPercent.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
    self.progressBarPercent.alpha = 1;
}

- (void)updateCounter:(NSTimer *)tmr {
    NSTimeInterval timer = [_allDate timeIntervalSinceNow];
    int days = timer / (60 * 60 * 24);
    timer -= days * (60 * 60 * 24);
    int hours = timer / (60 * 60);
    timer -= hours * (60 * 60);
    int minutes = timer / 60;
    timer -= minutes * 60;
    int seconds = timer;
    self.daysLeft.text = [NSString stringWithFormat:@"%02d days \n %02d hours \n %02d minutes \n%02d seconds", days, hours, minutes, seconds];
    if (days + hours + minutes + seconds <= 0) {
        [tmr invalidate];
    }
}

- (IBAction)changeView:(id)sender {
    
    if (self.progressBar.hidden) {
        [self.progressBar setValue:0 animateWithDuration:0];
        self.progressBar.hidden = NO;
        self.progressBar.alpha = 0;
        [UIView animateWithDuration:1.5 animations:^{
            self.progressBarPercent.alpha = 0;
            self.progressBar.alpha = 1;
        } completion:^(BOOL finished) {
            [self configureProgressBar];
        }];
        
    } else {
        
        [UIView animateWithDuration:1.5 animations:^{
            self.progressBar.alpha = 0;
            self.progressBarPercent.alpha = 1;
        } completion:^(BOOL finished) {
            [self configureProgressBarPercent];
            self.progressBar.hidden = YES;
        }];
    }
}

- (void) configureProgressBarPercent {
    [self resetValue:self.progressBar];
    [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1];
}

- (void) configureProgressBar {
    [self resetValue:self.progressBarPercent];
    [self.progressBar setValue:[_person calculateLeftDays] animateWithDuration:1];
}

- (void) resetValue: (MBCircularProgressBarView*) progressBar {
    [progressBar setValue:0 animateWithDuration:0];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* segueName = segue.identifier;
    [segueName isEqualToString:@"editSegue"];
    EditViewController* editView = (EditViewController*) [segue destinationViewController];
    editView.index = self.index;
}

- (void) setVkItem {
    
}

- (void) makeScreenshot {
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
}
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
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end