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
#import <QuartzCore/QuartzCore.h>
#import <ClusterPrePermissions/ClusterPrePermissions.h>

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
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.jpg"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

-(void) observeState {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setViewState)
                                                 name: @"appStateChanged"
                                               object: nil];
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
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Так точно!" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Дезертирую!" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) createInstagramAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                   message:@"Instagram не установлен"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Понял" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void) createAddAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ты не новобранец, а матёрый дед? Скачай полную версию!" message:@"В этой версии можно добавить только одного бойца." preferredStyle:UIAlertControllerStyleAlert];
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

-(UIImage*) makeScreenshot {
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    return screenshot;
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

- (void)saveImage: (UIImage*)image {
    if (image != nil) {
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:[self getPathWithImage] atomically:YES];
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
                                     
                                 } else {
                                     
                                 }
                             }];
}

- (UIImage*)loadImage {
    return [UIImage imageWithContentsOfFile:[self getPathWithImage]];
}

- (NSString*) getPathWithImage {
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDirectory stringByAppendingPathComponent: @"test.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
