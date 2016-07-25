//
//  OathViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 22.07.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "OathViewController.h"

@interface OathViewController ()

@end

@implementation OathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [self loadImage];
    self.oathLabel.text = @"«Я, (фамилия, имя, отчество), торжественно присягаю на верность своему Отечеству — Российской Федерации. Клянусь свято соблюдать Конституцию Российской Федерации, строго выполнять требования воинских уставов, приказы командиров и начальников. Клянусь достойно исполнять воинский долг, мужественно защищать свободу, независимость и конституционный строй России, народ и Отечество»";
    self.oathLabel.numberOfLines = 0;
}


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewControllerCancelled" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
