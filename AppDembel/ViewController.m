//
//  ViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "MGSwipeTableCell.h"
#import "Reachability.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "AddViewController.h"
#import "OathViewController.h"
#import "Quotations.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray* nameArray;
    NSMutableArray* dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundMyView:_menuButton borderRadius:15.0f borderWidth:0.0f color:nil];
    [self performSelector:@selector(createPermission) withObject:nil afterDelay:2];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showQuotation) userInfo:nil repeats:NO];
    [self checkFirstLaunch];
}

- (void) showQuotation {
    NSUInteger randomIndex = arc4random() % [[Quotations getArray]  count];
    self.label.text = [[Quotations getArray] objectAtIndex:randomIndex];
}

- (void)showGrid {
    NSInteger numberOfOptions = 4;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cogwheel"] title:@"Настройки"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"interface"] title:@"Присяга"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"error"] title:@"Отменить"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"plus"] title:@"Добавить"],
                       ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    self.imageView.image = [self loadImage];
    [Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.contentSize.height);
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(showQuotation) userInfo:nil repeats:YES];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.people count];
}

- (void) checkFirstLaunch {
    if (self.model.people.count > 0) {
        self.firstLaunchView.hidden = YES;
    }
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
    cell.rightSwipeSettings.transition = MGSwipeTransitionRotate3D;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue"]) {
        [self checkNetworkReachability];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.index = indexPath.row;
    }
}

- (void) checkNetworkReachability {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (!(networkStatus == NotReachable)) {
        [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        [self performSelector:@selector(moveToSettingsViewController) withObject:nil afterDelay:0.5f];
    } else if (itemIndex == 1)
        [self performSelector:@selector(moveToOathViewController) withObject:nil afterDelay:0.5f];
    if (itemIndex == 3)
        (self.model.people.count == 1) ? [self createAddAlert] :  [self performSelector:@selector(moveToAddViewController) withObject:nil afterDelay:0.5f];
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
}

- (void) moveToSettingsViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) moveToAddViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) moveToOathViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    OathViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OathViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showMenu:(id)sender {
    [self showGrid];
}
@end
