//
//  OathViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 22.07.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "OathViewController.h"
#import "Reachability.h"

@interface OathViewController () <AppodealInterstitialDelegate>

@end

@implementation OathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [self loadImage];
    self.oathLabel.text = @"«Я, (фамилия, имя, отчество), торжественно присягаю на верность своему Отечеству — Российской Федерации. Клянусь свято соблюдать Конституцию Российской Федерации, строго выполнять требования воинских уставов, приказы командиров и начальников. Клянусь достойно исполнять воинский долг, мужественно защищать свободу, независимость и конституционный строй России, народ и Отечество»";
    self.oathLabel.numberOfLines = 0;
    [self roundMyView:_backButton borderRadius:15.0f borderWidth:0.0f color:nil];
    [Appodeal setInterstitialDelegate:self];
}


- (IBAction)backButton:(id)sender {
    [self checkNetworkReachability];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewControllerCancelled" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@end
