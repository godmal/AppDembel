//
//  ViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class People;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}

@property (strong, nonatomic) People* model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
