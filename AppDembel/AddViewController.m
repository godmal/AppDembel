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
#import "ViewController.h"
#import "DateUtils.h"

@interface AddViewController ()

@end

@implementation AddViewController{
    NSDate* _date;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor whiteColor];
    [self.dateInput setInputView:datePicker];
   
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

- (IBAction)removeButton:(id)sender {
    [self.model removeAll];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0)  {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Введи данные" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Так точно!" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Дезертирую!" style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
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
