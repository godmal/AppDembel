//
//  ViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RNGridMenu.h"

@interface ViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, RNGridMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
- (IBAction)showMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
