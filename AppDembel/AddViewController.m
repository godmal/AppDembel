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

- (IBAction)savePerson:(id)sender {
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0)  {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Введи данные" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Передумал" style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.model add:[[Person alloc] initWithName:self.nameInput.text andDate:_date]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) moveToHomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"Home" ];
    [self.navigationController pushViewController:home animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
