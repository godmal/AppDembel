//
//  ViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)buttonClick:(id)sender;

@end
