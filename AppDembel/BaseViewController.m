//
//  BaseViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 14.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "BaseViewController.h"
#import "PeopleStore.h"
#import "People.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self observeState];
        [self configureModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    //[Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
}

-(void) observeState {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setViewState)
                                                 name: @"appStateChanged"
                                               object: nil];
}

-(void) createDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
}

-(void) setViewState {
    [self configureModel];
    [self viewDidLoad];
}

-(void) configureModel {
    PeopleStore* store = [[PeopleStore alloc] init];
    self.model = [[People alloc] initWithStore:store];
    
}

-(void) createAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Введи данные" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Так точно!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Дезертирую!" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) createEditAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"alallalalaal" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Так точно!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];

    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL) isInstagramInstalled {
    NSURL *appURL = [NSURL URLWithString:@"instagram://app"];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

- (void) hide:(UIView*) view {
    view.hidden = YES;
}

- (void) show:(UIView*) view {
    view.hidden = NO;
}

- (void) show:(UIView*) showingView andHide:(UIView*) hidingView {
    [self show: showingView];
    [self hide: hidingView];
}

- (void)roundMyView:(UIView*)view borderRadius:(CGFloat)radius borderWidth:(CGFloat)border color:(UIColor*)color {
    CALayer *layer = [view layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.borderColor = color.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
