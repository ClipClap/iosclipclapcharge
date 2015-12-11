//
//  ViewController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/7/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (IBAction)changeEnviroment:(id)sender {
    
    UISegmentedControl *enviroment = sender;
    
    //Development
    if (enviroment.selectedSegmentIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ClipClapChargeDevelopment"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"changeEnviroment: YES");
    }
    //Production
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ClipClapChargeDevelopment"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"changeEnviroment: NO");
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //-------------------------------------------
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.855 green:0.208 blue:0.208 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.855 green:0.208 blue:0.208 alpha:1]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ClipClapChargeDevelopment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"viewDidLoad: YES");
}

@end
