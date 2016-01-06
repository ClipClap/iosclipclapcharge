//
//  ViewController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/7/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *itemByItemButton;
@property (strong, nonatomic) IBOutlet UIButton *totalTaxTipButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    float radious = self.itemByItemButton.bounds.size.width / 15.0;
    
    self.itemByItemButton.layer.cornerRadius = radious;
    self.totalTaxTipButton.layer.cornerRadius = radious;
    
    //-------------------------------------------
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.855 green:0.208 blue:0.208 alpha:1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.855 green:0.208 blue:0.208 alpha:1]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
