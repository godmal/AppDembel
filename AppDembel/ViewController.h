//
//  ViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class People;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}

@property (strong, nonatomic) People* model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void)roundMyView:(UIView*)view
       borderRadius:(CGFloat)radius
        borderWidth:(CGFloat)border
              color:(UIColor*)color;

@end
