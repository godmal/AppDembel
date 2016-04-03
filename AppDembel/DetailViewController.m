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

    
    _person = [self.model.people objectAtIndex:self.index];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.nameLabel.text = _person.name;
    self.dateLabel.text = [DateUtils convertDateToString:_person.date];
    self.demobilizationDateLabel.text = [DateUtils convertDateToString:[_person calculateDemobilizationDate]];
    if ([DateUtils isAfterNow:_person.date]) {
        
        [self show: self.daysLeft andHide:self.progressBar];
        int daysLeft = (int)[DateUtils getDaysBetween: [NSDate date] and:_person.date];
        self.daysLeft.text = [NSString stringWithFormat:@"Осталось до службы: %d дней", daysLeft];
    } else {
        [self show: self.progressBar andHide:self.daysLeft];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    if (![DateUtils isAfterNow:_person.date]) {
        [self.progressBar setValue:[_person calculateLeftDays] animateWithDuration:2];
        self.progressBar.maxValue = 365;
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


@end
