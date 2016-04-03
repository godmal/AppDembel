//
//  BaseViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 14.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class People;
@class Person;

@interface BaseViewController : UIViewController 


@property (strong, nonatomic) People* model;
@property (strong, nonatomic) Person* person;

-(void) createAlert;

@end
