//
//  AddViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 03.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "AddViewController.h"
#import "People.h"
#import "Person.h"
#import "PeopleStore.h"
#import "DateUtils.h"

@interface AddViewController ()

@end

@implementation AddViewController{
    NSDate* _date;
    UIDatePicker *_datePicker;
}


//TODO: VALIDATION DATAPICKERVALUES
- (void)viewDidLoad {
    [super viewDidLoad];
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.minimumDate = [DateUtils minLimitDate];
    [_datePicker setDate:[NSDate date]];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateInput setInputView:_datePicker];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    _date = picker.date;
    NSDateFormatter *dateFormat = [DateUtils getFormatter];
    NSString* dateString = [dateFormat stringFromDate:_date];
    self.dateInput.text = [NSString stringWithFormat:@"%@",dateString];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameInput resignFirstResponder];
    return YES;
}

- (IBAction)saveButtonClick:(id)sender {
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0)  {
        [self createAlert];
    } else {
        [self savePerson];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) savePerson {
    [self.model add:[[Person alloc] initWithName:self.nameInput.text andDate:_date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
