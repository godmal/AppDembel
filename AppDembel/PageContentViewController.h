//
//  PageContentViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@class MBCircularProgressBarView;

@interface PageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property (assign) float progress;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressView;

@end
