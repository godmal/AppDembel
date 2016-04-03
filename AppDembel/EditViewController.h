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

@property (assign, nonatomic) NSUInteger index;

- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;

@end
