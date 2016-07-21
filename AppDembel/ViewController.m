//
//  ViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "DetailViewController.h"
#import "MGSwipeTableCell.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray* nameArray;
    NSMutableArray* dateArray;
    UIImagePickerController* imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundMyView:_addButton borderRadius:15.0f borderWidth:0.0f color:nil];
    [self roundMyView:_tableView borderRadius:15.0f borderWidth:0.0f color:nil];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.imageView.image = [self loadImage];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
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
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Удалить" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        [tableView beginUpdates];
        [self.model removePerson:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        [self.tableView reloadData];
        return YES;
    }], ];
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue"]) {
        [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:self];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.index = indexPath.row;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
