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
#import "DetailViewController.h"
#import "DateUtils.h"
#import "MGSwipeTableCell.h"
#import "EditViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray* nameArray;
    NSMutableArray* dateArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self observeState];
        [self setViewState];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundMyView:_addButton borderRadius:5.0f borderWidth:0.0f color:nil];
    [self roundMyView: _tableView borderRadius:15.0f borderWidth:0.0f color:nil];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) observeState {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setViewState)
                                                 name: @"appStateChanged"
                                               object: nil];
}

-(void) setViewState {
    PeopleStore* store = [[PeopleStore alloc] init];
    self.model = [[People alloc] initWithStore:store];
    [self viewDidLoad];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"Cell";
    MGSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = [[self.model getAllNames] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[self.model getAllDatesStrings] objectAtIndex:indexPath.row];
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender)
    {
        EditViewController* modalViewController=[[EditViewController alloc] init];
        [self presentViewController:modalViewController animated:YES completion:nil];
        return YES;
    }],];

    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender)
    {
        [self.model removePerson:indexPath.row];
        [self.tableView reloadData];
        return YES;
    }], ];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    [self roundMyView: cell borderRadius:15.0f borderWidth:0.0f color:nil];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.person = [self.model.people objectAtIndex:indexPath.row];
    }
}

- (void) fillTableRow {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)roundMyView:(UIView*)view borderRadius:(CGFloat)radius borderWidth:(CGFloat)border color:(UIColor*)color {
    CALayer *layer = [view layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.borderColor = color.CGColor;
}

@end
