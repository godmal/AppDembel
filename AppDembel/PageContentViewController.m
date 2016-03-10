//
//  PageContentViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "PageContentViewController.h"
#import "MBCircularProgressBarView.h"


@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    if (self.pageIndex == 1) {
        self.progressView.decimalPlaces = 0;
        self.progressView.maxValue = 365;
        self.progressView.unitString = @" days";
    }
    [self.progressView setValue:self.progress animateWithDuration: 0.5f];
}

@end
