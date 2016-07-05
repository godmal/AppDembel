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
#import "DateUtils.h"
#import "HSDatePickerViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController{
    NSDate* _date;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundMyView:_saveButton borderRadius:15.0f borderWidth:0.0f color:nil];

    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.minimumDate = [DateUtils minLimitDate];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setDate:[DateUtils now]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateInput setInputView:datePicker];
}

- (void) viewWillAppear:(BOOL)animated {
    [Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    _date = picker.date;
    NSString* dateString = [[DateUtils getFormatter] stringFromDate:_date];
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
    [self.model add:[[Person alloc] initWithName:self.nameInput.text andDate:_date andEndDate:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
