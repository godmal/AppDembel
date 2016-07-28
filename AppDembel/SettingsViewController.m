//
//  SettingsViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 22.07.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"

@interface SettingsViewController () <MFMailComposeViewControllerDelegate, AppodealInterstitialDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Appodeal setInterstitialDelegate:self];
    self.imageView.image = [self loadImage];
    [self roundMyView:_backButton borderRadius:15.0f borderWidth:0.0f color:nil];
    self.aboutLabel.text = @"О приложении:\nПораДомой помогает легко следить за прогрессом службы, рассказать о нелёгких армейских буднях друзьям в социальных сетях и не позволит пропустить дембель своего друга, брата или молодого человека. В облегченной версии:\n - фон изменить нельзя;\n - назойливая реклама;\n - добавление одного бойца.";
    NSArray *buttonsArray = @[self.firstButton, self.secondButton, self.thirdButton];
    for (UIButton* button in buttonsArray) {
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0;
    }

}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)interstitialDidDismiss {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ты не новобранец, а матёрый дед? Купи полную версию!" message:@"В полной версии нет рекламы и есть дополнительные функции" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Не хочу" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Обновить!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   NSLog(@"Идем в AppStore");
                                               }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
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
- (IBAction)changeBack:(id)sender {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Функция недоступна в этой версии. Обновить?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Не хочу" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Обновить!" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSLog(@"Идем в AppStore");
                                                       }];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sendEmail:(id)sender {
    NSString *emailTitle = @"Отзыв/ошибка";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"developer.gorbachev@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)upgradeButton:(id)sender {
    [self checkNetworkReachability];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
