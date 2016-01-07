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

@interface TotalPaymentController() <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *paymentDescription;
@property (strong, nonatomic) IBOutlet UITextField *netTotal;
@property (strong, nonatomic) IBOutlet UITextField *taxTotal;
@property (strong, nonatomic) IBOutlet UITextField *tip;

@property (strong, nonatomic) UIResponder *currentResponder;
@end

@implementation TotalPaymentController

#pragma mark - My Methods

- (IBAction)commitPayment:(id)sender {
    
    [self.view endEditing:YES];
    
    //---------------------------------------------------------------------------------
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
    self.navigationItem.title = @"Pagando";
    
    //---------------------------------------------------------------------------------
    
    if (self.paymentDescription.text.length == 0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [activityIndicator stopAnimating];
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El campo Descripción no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        
        return;
    }
    
    if (self.netTotal.text.length == 0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [activityIndicator stopAnimating];
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El compo Compra Neta no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.taxTotal.text.length == 0)
    {
        self.navigationItem.leftBarButtonItem = nil;
        [activityIndicator stopAnimating];
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"El compo Total Impuestos no debe estar vacío"
                                   delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil] show];
        return;
    }
    
    //---------------------------------------------------------------------------------
    
    //Initializing the payment object with the mandatory secret key
    [CCBilleteraPayment shareInstance].secretkey = self.secretKey;
    
    //Reseting all info in the sigleton object
    [[CCBilleteraPayment shareInstance] resetItems];
    
    //Setting my unirversal linking to enable Billetera App to send me callback parameters about the status of the payment
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        [CCBilleteraPayment shareInstance].universalLinlCallback = @"";
    }
    else
    {
        [CCBilleteraPayment shareInstance].urlSchemeCallback = @"PayAndGoSample://";
    }
    
    //---------------------------------------------------------------------------------
    
    NSString *netTotal = [self.netTotal.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    netTotal = [netTotal stringByReplacingOccurrencesOfString:@"." withString:@""];
    netTotal = [netTotal stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *taxTotal = [self.taxTotal.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    taxTotal = [taxTotal stringByReplacingOccurrencesOfString:@"." withString:@""];
    taxTotal = [taxTotal stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *tip = [self.tip.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    tip = [tip stringByReplacingOccurrencesOfString:@"." withString:@""];
    tip = [tip stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    if (self.tip.text.length == 0)
    {
        [[CCBilleteraPayment shareInstance] addTotalWithValue:[netTotal intValue]
                                                          tax:[taxTotal intValue]
                                               andDescription:self.paymentDescription.text];
    }
    else
    {
        [[CCBilleteraPayment shareInstance] addTotalWithValue:[netTotal intValue]
                                                          tax:[taxTotal intValue]
                                                          tip:[tip intValue]
                                               andDescription:self.paymentDescription.text];
    }
    
    //---------------------------------------------------------------------------------
    
    [[CCBilleteraPayment shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
        
        [activityIndicator stopAnimating];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = @"Paga con Billetera";
        
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error Getting Token"
                                        message:error.userInfo[NSLocalizedDescriptionKey]
                                       delegate:nil
                              cancelButtonTitle:@"Cerrar"
                              otherButtonTitles:nil] show];
        }
        else
        {
            [[CCBilleteraPayment shareInstance] commitPaymentWithToken:token];
        }
    }];
}

- (void) goToNextTexField{
    
    if ([self.currentResponder isEqual:self.paymentDescription])
    {
        [self.netTotal becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.netTotal])
    {
        [self.taxTotal becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.taxTotal])
    {
        [self.tip becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.tip])
    {
        [self.paymentDescription becomeFirstResponder];
    }
}

- (void) goToPreviousTexField{
    
    if ([self.currentResponder isEqual:self.paymentDescription])
    {
        [self.tip becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.netTotal])
    {
        [self.paymentDescription becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.taxTotal])
    {
        [self.netTotal becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.tip])
    {
        [self.taxTotal becomeFirstResponder];
    }
}

- (void) hideKeyboard{
    
    [self.view endEditing:YES];
}

#pragma mark - UIViewController Methods

- (void) viewDidLoad{
    
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 568, 44)];
    toolbar.translucent = YES;
    [toolbar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"--->"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToNextTexField)];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"<---"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToPreviousTexField)];
    
    UIBarButtonItem *hideButton = [[UIBarButtonItem alloc] initWithTitle:@"Esconder"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(hideKeyboard)];
    
    toolbar.items = @[hideButton, flexibleButton, previousButton, nextButton];
    textField.inputAccessoryView = toolbar;
    self.currentResponder = textField;
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && ![textField isEqual:self.paymentDescription])
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && ![textField isEqual:self.paymentDescription])
    {
        NSString *numberFormatted = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[textField.text doubleValue]]
                                                                     numberStyle:NSNumberFormatterDecimalStyle];
        
        textField.text = [NSString stringWithFormat:@"$%@", numberFormatted];
    }
}


@end
