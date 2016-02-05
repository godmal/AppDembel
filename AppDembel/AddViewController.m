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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)removeButton:(id)sender {
    [self.model removeAll];
}

- (IBAction)savePerson:(id)sender {
    NSString* name = self.name.text;
    NSString* date = self.date.text;
    [self.model add:[[Person alloc] initWithName:name andDate:date]];
    NSLog(@"%@", self.model.people);
    self.name.text = self.date.text = @"";
    [self moveToHomeView];
}

-(void) moveToHomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"Home" ];
    [self.navigationController pushViewController:home animated:YES];
}

@end
