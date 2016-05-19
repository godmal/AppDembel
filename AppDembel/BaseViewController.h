//
//  BaseViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 14.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Appodeal/Appodeal.h>

@class People;
@class Person;

@interface BaseViewController : UIViewController 

@property (strong, nonatomic) People* model;
@property (strong, nonatomic) Person* person;

//-(id) getCurrentPerson;
-(void) createAlert;
-(void) createEditAlert;
-(void) show:(UIView*) view;
-(void) hide:(UIView*) view;
-(void) show:(UIView*) showingView andHide:(UIView*) hidingView;
- (void)roundMyView:(UIView*)view
       borderRadius:(CGFloat)radius
        borderWidth:(CGFloat)border
              color:(UIColor*)color;
@end
