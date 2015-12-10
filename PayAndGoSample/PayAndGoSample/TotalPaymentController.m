//
//  TotalPaymentController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/7/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "TotalPaymentController.h"
#import <ClipClapCharge/ClipClapCharge.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface TotalPaymentController()

@property (strong, nonatomic) IBOutlet UITextField *paymentDescription;
@property (strong, nonatomic) IBOutlet UITextField *netTotal;
@property (strong, nonatomic) IBOutlet UITextField *taxTotal;
@property (strong, nonatomic) IBOutlet UITextField *tip;

@end

@implementation TotalPaymentController

- (IBAction)commitPayment:(id)sender {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
    self.navigationItem.title = @"Pagando";
    
    if (self.paymentDescription.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El campo Descripción no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        
        return;
    }
    
    if (self.netTotal.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El compo Compra Neta no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.taxTotal.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El compo Total Impuestos no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        return;
    }
    
    BOOL isDevelopment = [[NSUserDefaults standardUserDefaults] boolForKey:@"ClipClapChargeDevelopment"];
    
    //Development
    if (isDevelopment)
    {
        [CCBilleteraPayment shareInstance].secretkey = @"MIIwwHc8ksK8AfwUcWJC";
    }
    //Production
    else
    {
        [CCBilleteraPayment shareInstance].secretkey = @"pKFe1P2iYw6z73srBDBx";
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        [CCBilleteraPayment shareInstance].universalLinlCallback = @"";
    }
    else
    {
        [CCBilleteraPayment shareInstance].urlSchemeCallback = @"PayAndGoSample://";
    }
    
    if (self.tip.text.length == 0)
    {
        [[CCBilleteraPayment shareInstance] addTotalWithValue:[self.netTotal.text intValue]
                                                          tax:[self.taxTotal.text intValue]
                                               andDescription:self.paymentDescription.text];
    }
    else
    {
        [[CCBilleteraPayment shareInstance] addTotalWithValue:[self.netTotal.text intValue]
                                                          tax:[self.taxTotal.text intValue]
                                                          tip:[self.tip.text intValue]
                                               andDescription:self.paymentDescription.text];
    }
    
    
    [[CCBilleteraPayment shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
        
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:error.userInfo[NSLocalizedDescriptionKey]
                                       delegate:nil
                              cancelButtonTitle:@"Cerrar"
                              otherButtonTitles:nil] show];
        }
        else
        {
            
            [activityIndicator startAnimating];
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.title = @"Paga con Billetera";
            [[CCBilleteraPayment shareInstance] commitPaymentWithToken:token];
        }
    }];
    
//    //Initializing the payment object with the mandatory secret key
//    [CCBilleteraPayment shareInstance].secretkey = @"Your Secret Key";
//    
//    //Use this property if your app is running in iOS 9 or later and you want ClipClap Billetera open your app back gracefully
//    [CCBilleteraPayment shareInstance].universalLinlCallback = @"Your Universal Link";
//    
//    //Use this property if your app is running in iOS 8 or earlier and you want ClipClap Billetera open your app back gracefully
//    [CCBilleteraPayment shareInstance].urlSchemeCallback = @"Your URL Scheme";
//    
//    if (hasGivenTip)
//    {
//        //If the user has not given tip.
//        [[CCBilleteraPayment shareInstance] addTotalWithValue:[self.netTotal.text intValue]     //Total with out tax
//                                                          tax:[self.taxTotal.text intValue]     //The tax of the Total
//                                               andDescription:self.paymentDescription.text];    //A descriptive string of what you are charging
//    }
//    else
//    {
//        //If the user has given tip.
//        [[CCBilleteraPayment shareInstance] addTotalWithValue:[self.netTotal.text intValue]     //Total with out tax
//                                                          tax:[self.taxTotal.text intValue]     //The tax of the Total
//                                                          tip:[self.tip.text intValue]          //The tip the buyer will pay
//                                               andDescription:self.paymentDescription.text];    //A descriptive string of what you are charging
//    }
//    
//    //Getting the payment token to later commit the payment with the given information above
//    [[CCBilleteraPayment shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
//        
//        if (error)
//        {
//            //Logging the error, but the error must be shown to the user gracefully
//        }
//        else
//        {
//            //Here you must store in your data base the retreived payment token before commiting the payment. If this storing fails DO NOT COMMIT THE PAYMENT.
//            //Code here
//            
//            //Commiting the payment with the retreived payment token
//            [[CCBilleteraPayment shareInstance] commitPaymentWithToken:token];
//        }
//    }];
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
}
@end
