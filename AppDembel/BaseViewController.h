//
//  BaseViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 14.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKSdk.h"
#import <Appodeal/Appodeal.h>
#import "HMSideMenu.h"

@class People;
@class Person;

@interface BaseViewController : UIViewController 

@property (strong, nonatomic) People* model;
@property (strong, nonatomic) Person* person;

-(void) createAlert;
-(void) createInstagramAlert;
-(UIImage*) makeScreenshot;
-(void) show:(UIView*) view;
-(void) hide:(UIView*) view;
-(void) show:(UIView*) showingView andHide:(UIView*) hidingView;
- (void)roundMyView:(UIView*)view
       borderRadius:(CGFloat)radius
        borderWidth:(CGFloat)border
              color:(UIColor*)color;
- (void)saveImage: (UIImage*)image;
- (UIImage*)loadImage;
- (void) setIcon:(UIImage*) image for:(HMSideMenuItem*) item;

@end
