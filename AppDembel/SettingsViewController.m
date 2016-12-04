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

@implementation SettingsViewController  {
    UIImagePickerController* imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Appodeal setInterstitialDelegate:self];
    self.imageView.image = [self loadImage];
    [self roundMyView:_backButton borderRadius:15.0f borderWidth:0.0f color:nil];
    self.aboutLabel.text = @"В облегченной версии:\n - функция смены фона;\n - назойливая реклама;\n - добавление одного бойца.";
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
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ты не новобранец, а матёрый дед? Скачай полную версию!" message:@"В полной версии нет рекламы и есть дополнительные функции" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Не хочу" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Обновить!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   NSString *iTunesLink = @"https://itunes.apple.com/ru/app/poradomoj-dla-materyh-dedov/id1137886216?mt=8";
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
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
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    UIImage *img = [[UIImage alloc] initWithData:dataImage];
    [self saveImage:img];
    [self.imageView setImage:img];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendEmail:(id)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        picker.mailComposeDelegate = self;
        NSString *emailTitle = @"Отзыв/ошибка";
        NSArray *toRecipents = [NSArray arrayWithObject:@"developer.gorbachev@gmail.com"];
        NSString *messageBody = @"Привет!";
        [picker setSubject:emailTitle];
        [picker setToRecipients:toRecipents];
        [picker setMessageBody:messageBody isHTML:YES];
        [self presentViewController:picker animated:YES completion:NULL];
    }
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
