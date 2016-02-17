//
//  DetailViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "DetailViewController.h"
#import "DateUtils.h"
#import "Person.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSLog(@"%@", self.person.date);
    NSDateFormatter *dateFormatter = [DateUtils getFormatter];
    
    self.nameLabel.text = self.person.name;
    self.dateLabel.text = [dateFormatter stringFromDate:self.person.date];
    self.demobilizationDateLabel.text = [dateFormatter stringFromDate:[self.person calculateDemobilizationDate]];
    
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
