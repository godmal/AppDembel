//
//  EditViewController.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 28.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "EditViewController.h"
#import "People.h"
#import "Person.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

- (IBAction)editPerson:(id)sender {
    [self.model updatePersonBy:1 with:[[Person alloc] initWithName:@"ALoha" andDate:[NSDate date]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
