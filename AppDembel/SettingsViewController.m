//
//  SettingsViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 22.07.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [self loadImage];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeBack:(id)sender {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Функция недоступна в этой версии. Обновить?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Не хочу" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Так точно!" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSLog(@"Идем в AppStore");
                                                       }];
        [alert addAction:ok];
        [alert addAction:cancel];
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
