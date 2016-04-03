//
//  EditViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 09.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "EditViewController.h"
#import "Person.h"
#import "DateUtils.h"
#import "People.h"
#import "DetailViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController {
    Person* _person;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _person = [self.model.people objectAtIndex:self.index];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:_person.date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor colorWithRed:90/255.0 green:187/255.0 blue:181/255.0 alpha:1];
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateInput setInputView:datePicker];
    self.nameInput.text = _person.name;
    self.dateInput.text = [DateUtils convertDateToString:_person.date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    NSDateFormatter *dateFormat = [DateUtils getFormatter];
    _person.date = picker.date;
    NSString* dateString = [dateFormat stringFromDate:_person.date];
    self.dateInput.text = [NSString stringWithFormat:@"%@",dateString];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameInput resignFirstResponder];
    return YES;
}

- (IBAction)saveButton:(id)sender {
    
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0)  {
        [self createAlert];
    } else {
        
        Person* updatedPerson = [[Person alloc] initWithName:self.nameInput.text andDate:_person.date];
        [self.model updatePersonBy:self.index with:updatedPerson];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
