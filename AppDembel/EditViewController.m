//
//  EditViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 09.03.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "EditViewController.h"
#import "AddViewController.h"
#import "Person.h"
#import "DateUtils.h"
#import "ViewController.h"


@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:self.person.date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor colorWithRed:90/255.0 green:187/255.0 blue:181/255.0 alpha:1];
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateInput setInputView:datePicker];
    self.nameInput.text = self.person.name;
    self.dateInput.text = [DateUtils convertDateToString:self.person.date];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    NSDateFormatter *dateFormat = [DateUtils getFormatter];
    NSString* dateString = [dateFormat stringFromDate:picker.date];
    self.dateInput.text = [NSString stringWithFormat:@"%@",dateString];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameInput resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButton:(id)sender {
}
@end
