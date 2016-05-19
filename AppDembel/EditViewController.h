//
//  EditViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 09.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditViewController : BaseViewController 

- (IBAction)saveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;
@property (weak, nonatomic) IBOutlet UITextField *editEndDateInput;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (assign, nonatomic) NSUInteger index;


@end
