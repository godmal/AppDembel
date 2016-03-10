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
#import "ContainerViewController.h"
#import "EditViewController.h"

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString* segueName = segue.identifier;
    if ([segueName isEqualToString: @"containerSegue"]) {
        ContainerViewController* containerView = (ContainerViewController *) [segue destinationViewController];
        containerView.person = self.person;
    } else if ([segueName isEqualToString:@"editSegue"]) {
        EditViewController* editView = (EditViewController*) [segue destinationViewController];
        editView.person = self.person;
    }
    
}

//- (IBAction)changeView:(id)sender {
//    self.progressBar.decimalPlaces = 0;
//    self.progressBar.maxValue = 365;
//    self.progressBar.unitString = @" days";
//    [self.progressBar setValue:[self.person calculateDaysProgress] animateWithDuration:0.5f];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
