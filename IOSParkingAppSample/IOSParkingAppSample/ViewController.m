//
//  ViewController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/7/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ViewController.h"
#import "ItemsPaymentController.h"
#import "TotalPaymentController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *secretKeyTextField;
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
    
    UIColor *appColor = [UIColor colorWithRed:0.855 green:0.208 blue:0.208 alpha:1];
    [[UINavigationBar appearance] setBarTintColor:appColor];
    [self.navigationController.navigationBar setBarTintColor:appColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ItemByItem"])
    {
        ItemsPaymentController *controller = (ItemsPaymentController *)segue.destinationViewController;
        controller.secretKey = self.secretKeyTextField.text;
    }
    else if ([segue.identifier isEqualToString:@"TotalTaxTip"])
    {
        TotalPaymentController *controller = (TotalPaymentController *)segue.destinationViewController;
        controller.secretKey = self.secretKeyTextField.text;
    }
}

@end
