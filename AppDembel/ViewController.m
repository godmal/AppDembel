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
    PeopleStore* store;
    NSString* personName;
    NSMutableArray* stringArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        store = [[PeopleStore alloc] init];
        self.model = [[People alloc] initWithStore:store];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    store = [[PeopleStore alloc] init];
    NSArray* arrayID = [[store load] allKeys];
    return [arrayID count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    stringArray = [[NSMutableArray alloc] init];
    NSArray* numberArray = [[store load] allValues];
    for (Person* person in numberArray) {
        [stringArray addObject:person.name];
    }
    cell.textLabel.text = [stringArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
