//
//  AddViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "AddViewController.h"
#import "People.h"
#import "Person.h"
#import "DateUtils.h"
#import "Reachability.h"

@interface AddViewController () <AppodealInterstitialDelegate>

@end

@implementation AddViewController{
    NSDate* _date;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundMyView:_saveButton borderRadius:15.0f borderWidth:0.0f color:nil];
    self.imageView.image = [self loadImage];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.minimumDate = [DateUtils minLimitDate];
    [datePicker setDate:[DateUtils now]];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateInput setInputView:datePicker];
    [Appodeal setInterstitialDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
}

- (IBAction)saveButton:(id)sender {
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0)  {
        [self createAlert];
    } else {
        [self savePerson];
        [self checkNetworkReachability];
    }
}

-(void) savePerson {
    [self.model add:[[Person alloc] initWithName:self.nameInput.text andDate:_date andEndDate:nil]];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    _date = picker.date;
    NSString* dateString = [[DateUtils getFormatter] stringFromDate:_date];
    self.dateInput.text = [NSString stringWithFormat:@"%@",dateString];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameInput resignFirstResponder];
    return YES;
}

- (void)interstitialDidDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkNetworkReachability {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    (networkStatus == NotReachable) ? [self createInternetConnectionAlert] : [self showFullscreenAd];
}

- (void) showFullscreenAd {
    [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:self];
}

- (void) createInternetConnectionAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Где твой интернет, боец?!"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Сейчас будет!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self interstitialDidDismiss];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
