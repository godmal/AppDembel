//
//  ViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "Person.h"
#import "PeopleStore.h"

@interface ViewController ()

@end

@implementation ViewController {
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setViewState];
        [self observeState];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    NSLog(@"%@", self.model.people);
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void) setViewState {
    PeopleStore* store = [[PeopleStore alloc] init];
    self.model = [[People alloc] initWithStore:store];
    [self viewDidLoad];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* arrayID = [self.model.people allKeys];
    return [arrayID count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableArray* stringArray = [[NSMutableArray alloc] init];
    NSArray* numberArray = [self.model.people allValues];
    for (Person* person in numberArray) {
        [stringArray addObject:person.name];
    }
    cell.textLabel.text = [stringArray objectAtIndex:indexPath.row];
    return cell;
}

-(void) observeState {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setViewState)
                                                 name: @"appStateChanged"
                                               object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
