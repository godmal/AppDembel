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
    [self roundMyView:_saveButton borderRadius:15.0f borderWidth:0.0f color:nil];

    _person = [self.model.people objectAtIndex:self.index];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = [self setColor];
    [self setColorForDatePicker:datePicker];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:_person.date];
    datePicker.minimumDate = [DateUtils minLimitDate];
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]init];
    endDatePicker.backgroundColor = [self setColor];
    [self setColorForDatePicker:endDatePicker];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setDate:_person.endDate];
    endDatePicker.minimumDate = [DateUtils now];
    [endDatePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [self.dateInput setInputView:datePicker];
    [self.editEndDateInput setInputView:endDatePicker];
    
    self.nameInput.text = _person.name;
    self.dateInput.text = [DateUtils convertDateToString:_person.date];
    self.editEndDateInput.text = [DateUtils convertDateToString:_person.endDate];
}

- (void) viewWillAppear:(BOOL)animated {
    //[Appodeal showAd:AppodealShowStyleBannerBottom rootViewController:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateInput.inputView;
    UIDatePicker *editPicker = (UIDatePicker*)self.editEndDateInput.inputView;
    NSDateFormatter *dateFormat = [DateUtils getFormatter];
    _person.date = picker.date;
    _person.endDate = editPicker.date;
    
    if ([DateUtils getDaysBetween:_person.date and:_person.endDate] < 365) {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setYear:1];
            _person.endDate = [[DateUtils getCalendar] dateByAddingComponents:components toDate:_person.date options:0];
            NSString* endDateString = [dateFormat stringFromDate:_person.endDate];
            self.editEndDateInput.text = [NSString stringWithFormat:@"%@",endDateString];
            [editPicker setDate:_person.endDate];
    }
    
    NSString* dateString = [dateFormat stringFromDate:_person.date];
    self.dateInput.text = [NSString stringWithFormat:@"%@",dateString];
    NSString* endDateString = [dateFormat stringFromDate:_person.endDate];
    self.editEndDateInput.text = [NSString stringWithFormat:@"%@",endDateString];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameInput resignFirstResponder];
    return YES;
}

- (IBAction)saveButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditViewControllerCancelled" object:nil];
    
    if ([self.nameInput.text length] == 0 || [self.dateInput.text length] == 0) {
        [self createAlert];
    } else {
        Person* updatedPerson = [[Person alloc] initWithName:self.nameInput.text andDate:_person.date andEndDate:_person.endDate];
        [self.model updatePersonBy:self.index with:updatedPerson];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
