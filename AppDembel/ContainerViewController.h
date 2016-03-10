//
//  ContainerViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ContainerViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) NSArray* slides;
@property (strong, nonatomic) Person* person;

@end
