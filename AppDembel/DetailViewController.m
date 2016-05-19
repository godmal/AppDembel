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

@interface DetailViewController ()

@end

@implementation DetailViewController {
    Person* _person;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:     UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:10];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.editButton, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetViewParameters)
                                                 name:@"EditViewControllerCancelled"
                                               object:nil];
    
    HMSideMenuItem *twitterItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(40, 40) action:^{
        UIView* myView = [[UIView alloc] initWithFrame:self.view.window.bounds];;
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        myView.alpha = 1;
        [UIView animateWithDuration:1.5f animations:^{
            myView.backgroundColor = [UIColor whiteColor];
            myView.alpha = 0;
            [currentWindow addSubview:myView];
        } completion:^(BOOL finished) {
            [myView removeFromSuperview];
            CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
            CGFloat scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
            
            [layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
            
//            CGRect rect = [[UIScreen mainScreen] bounds];
//            UIGraphicsBeginImageContext(rect.size);
//            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
        }];
        
        NSLog(@"tapped twitter item");
    }];
    UIImageView *twitterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [twitterIcon setImage:[UIImage imageNamed:@"twitter"]];
    [twitterItem addSubview:twitterIcon];
    
    HMSideMenuItem *emailItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(40, 40) action:^{
        NSLog(@"tapped email item");
    }];
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30 , 30)];
    [emailIcon setImage:[UIImage imageNamed:@"email"]];
    [emailItem addSubview:emailIcon];
    
    HMSideMenuItem *facebookItem = [[HMSideMenuItem alloc] initWithSize:CGSizeMake(40, 40) action:^{
        NSLog(@"tapped facebook item");
    }];
    UIImageView *facebookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 35, 35)];
    [facebookIcon setImage:[UIImage imageNamed:@"facebook"]];
    [facebookItem addSubview:facebookIcon];

    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[twitterItem, emailItem, facebookItem]];
    [self.sideMenu setItemSpacing:10.0f];
    [self.view addSubview:self.sideMenu];

}

-(void) viewWillAppear:(BOOL)animated {
        _person = [self.model.people objectAtIndex:self.index];
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
    self.progressBar.hidden = YES;

}

- (void) openPLS {
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
- (void) viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(openPLS) withObject:nil afterDelay:3];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.progressBar.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.progressBarPercent.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
    }];
    if (![DateUtils isAfterNow:_person.date]) {
        [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:1];
    }
}

- (void)updateCounter:(NSTimer *)tmr {
    NSTimeInterval timer = [_person.date timeIntervalSinceNow];
    int days = timer / (60 * 60 * 24);
    timer -= days * (60 * 60 * 24);
    int hours = timer / (60 * 60);
    timer -= hours * (60 * 60);
    int minutes = timer / 60;
    timer -= minutes * 60;
    int seconds = timer;
    self.daysLeft.text = [NSString stringWithFormat:@"%02d days \n %02d hours \n %02d minutes \n%02d seconds", days, hours, minutes, seconds];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
