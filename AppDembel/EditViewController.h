//
//  EditViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 09.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface EditViewController : UIViewController 
@property (strong, nonatomic) Person* person;
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;

@end
