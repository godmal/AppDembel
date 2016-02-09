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

@interface AddViewController ()

@end

@implementation AddViewController{
    NSString* dateString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor whiteColor];
    [self.date setInputView:datePicker];
}

-(void) dateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.date.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    dateString = [dateFormat stringFromDate:eventDate];
    self.date.text = [NSString stringWithFormat:@"%@",dateString];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.name resignFirstResponder];
    return YES;
}

- (IBAction)removeButton:(id)sender {
    [self.model removeAll];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePerson:(id)sender {
    NSString* name = self.name.text;
    NSString* date = self.date.text;
    [self.model add:[[Person alloc] initWithName:name andDate:date]];
    NSLog(@"%@", self.model.people);
    self.name.text = self.date.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
 
}

-(void) moveToHomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"Home" ];
    [self.navigationController pushViewController:home animated:YES];
}


//-(void) refresh {
//    ViewController *wc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
//                       instantiateViewControllerWithIdentifier:@"Home"];
//    [self.navigationController pushViewController:wc animated:YES];
//}
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
