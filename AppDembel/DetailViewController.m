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
#import "ContainerViewController.h"
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

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* segueName = segue.identifier;
    if ([segueName isEqualToString: @"containerSegue"]) {
        ContainerViewController* containerView = (ContainerViewController *) [segue destinationViewController];
        containerView.model = self.model;
        containerView.index = self.index;

    }
    [segueName isEqualToString:@"editSegue"];
    EditViewController* editView = (EditViewController*) [segue destinationViewController];
    editView.index = self.index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
