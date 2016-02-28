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
#import "MBCircularProgressBarView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
    self.nameLabel.text = self.person.name;
    self.dateLabel.text = [DateUtils convertDateToString:self.person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString:[self.person calculateDemobilizationDate]];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.progressBar setValue:[self.person calculatePercentProgress] animateWithDuration:0.5f];
    self.progressBar.decimalPlaces = 1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeView:(id)sender {
    self.progressBar.decimalPlaces = 0;
    self.progressBar.maxValue = 365;
    self.progressBar.unitString = @" days";
    [self.progressBar setValue:[self.person calculateDaysProgress] animateWithDuration:0.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
