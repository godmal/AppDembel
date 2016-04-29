//
//  DetailViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "DetailViewController.h"
#import "DateUtils.h"
#import "People.h"
#import "EditViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController {
    Person* _person;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSDate* demoDate =
    _person = [self.model.people objectAtIndex:self.index];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.nameLabel.text = _person.name;
    self.dateLabel.text = [DateUtils convertDateToString:_person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString:[_person calculateDemobilizationDate]];
    
    if ([DateUtils isAfterNow:_person.date]) {
        self.changeViewButton.enabled= NO;
        [self show: self.daysLeft andHide:self.progressBar];
        int daysLeft = (int)[DateUtils getDaysBetween: [NSDate date] and:_person.date];
        self.daysLeft.text = [NSString stringWithFormat:@"Осталось до службы: %d дней", daysLeft];
    } else {
        [self show: self.progressBar andHide:self.daysLeft];
    }
    self.progressBarPercent.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    if (![DateUtils isAfterNow:_person.date]) {
        [self.progressBar setValue:[_person calculateLeftDays] animateWithDuration:2];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* segueName = segue.identifier;
    [segueName isEqualToString:@"editSegue"];
    EditViewController* editView = (EditViewController*) [segue destinationViewController];
    editView.index = self.index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changeView:(id)sender {
    
    if (self.progressBarPercent.hidden) {
        self.progressBarPercent.hidden = NO;
        self.progressBarPercent.alpha = 0;
        
        [UIView animateWithDuration:2 animations:^{
            self.progressBar.alpha = 0;
            self.progressBarPercent.alpha = 1;
        } completion:^(BOOL finished) {
            [self configureProgressBarPercent];
        }];
    } else {
        
        [UIView animateWithDuration:2 animations:^{
            self.progressBarPercent.alpha = 0;
            self.progressBar.alpha = 1;
        } completion:^(BOOL finished) {
            [self configureProgressBar];
            self.progressBarPercent.hidden = YES;
        }];
    }
}

- (void) configureProgressBarPercent {
    [self resetValue:self.progressBar];
    [self.progressBarPercent setValue:[_person calculatePercentProgress] animateWithDuration:2];
}

- (void) configureProgressBar {
    [self resetValue:self.progressBarPercent];
    [self.progressBar setValue:[_person calculateLeftDays] animateWithDuration:2];
}

- (void) resetValue: (MBCircularProgressBarView*) progressBar {
    [progressBar setValue:0 animateWithDuration:2];
}

@end
