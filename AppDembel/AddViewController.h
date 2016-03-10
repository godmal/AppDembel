//
//  AddViewController.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "ViewController.h"

@interface AddViewController: ViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;
- (IBAction)saveButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (void) savePerson;

@end