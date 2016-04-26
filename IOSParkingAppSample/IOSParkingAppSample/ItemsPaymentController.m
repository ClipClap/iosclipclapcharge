//
//  ViewController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ItemsPaymentController.h"
#import "ItemCell.h"
#import "HUDHandler.h"
#import <ClipClapCharge/ClipClapCharge.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//---------------------------------------------------------------------

#define ADD_CELL_TYPE @"AddItemCell"
#define ITEM_CELL_TYPE @"ItemCell"

//---------------------------------------------------------------------

@interface ItemsPaymentController ()
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

//---------------------------------------------------------------------

@implementation ItemsPaymentController

- (NSString *) getUUIDToken{
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

- (NSString *) getNoDashUUIDToken{
    
    return [[self getUUIDToken] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *) getNoDashUUIDTokenWithLenght:(NSUInteger)lenght{
    
    NSUInteger uuidTimes = ceil(lenght / 32.0);
    NSString *uuid = @"";
    
    for (int i = 0; i < uuidTimes; i++)
    {
        uuid = [uuid stringByAppendingString:[self getNoDashUUIDToken]];
    }
    
    return [uuid substringToIndex:lenght];
}

- (void) showErrorMessage{

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Paga con Billetera";
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Uno o más campos estan vacíos"
                               delegate:nil
                      cancelButtonTitle:@"Cerrar"
                      otherButtonTitles:nil] show];
}

- (IBAction)payAction:(id)sender {
    
    [self.view endEditing:YES];
    
    //------------------------------------------------------------------
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
    self.navigationItem.title = @"Pagando";
    
    //------------------------------------------------------------------
    
    //Initializing the payment object with the mandatory secret key
    [CCBPaymentHandler shareInstance].secretkey = self.secretKey;
    
    //------------------------------------------------------------------
    
    //Creating a CCBPayment object with unique reference string
    CCBPayment *payment = [[CCBPayment alloc] initWithPaymentReference:[self getNoDashUUIDTokenWithLenght:10]];
    
    //Iterating all the cell to get the items information
    for (int i = 0; i < self.dataSource.count - 1; i++)
    {
        ItemCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (cell.itemName.text.length == 0 || [cell.itemName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [activityIndicator stopAnimating];
            [self showErrorMessage]; return;
        }
        
        if (cell.itemPrice.text.length == 0 || [cell.itemPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [activityIndicator stopAnimating];
            [self showErrorMessage]; return;
        }
        
        if (cell.itemCount.text.length == 0 || [cell.itemCount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            [activityIndicator stopAnimating];
            [self showErrorMessage]; return;
        }
        
        NSString *itemPrice = [cell.itemPrice.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        itemPrice = [itemPrice stringByReplacingOccurrencesOfString:@"." withString:@""];
        itemPrice = [itemPrice stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        //Adding the item information to the payment object
        [payment addItemWithName:cell.itemName.text
                           value:[itemPrice intValue]
                           count:[cell.itemCount.text intValue]
                      andTaxType:cell.taxType];
    }
    
    //------------------------------------------------------------------
    
    //Adding the payment object to the payment handler
    [CCBPaymentHandler shareInstance].payment = payment;
    
    //Getting the payment token to later commit the payment
    [[CCBPaymentHandler shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
        
        [[HUDHandler shareInstance] hideHUD];
        
        if (error)
        {
            //Logging the error, but the error must be shown to the user gracefully
            [[[UIAlertView alloc] initWithTitle:@"Error Getting Token"
                                        message:error.userInfo[NSLocalizedDescriptionKey]
                                       delegate:nil
                              cancelButtonTitle:@"Cerrar"
                              otherButtonTitles:nil] show];
        }
        else
        {
            //Commiting the payment with the retreive payment token
            [[CCBPaymentHandler shareInstance] commitPaymentWithToken:token andBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded)
                {
                    [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"done" title:@"Pago exitoso" andDetail:@"Pago realizado con éxito, gracias por usar ClipClap Billetera" inView:nil];
                }
                else
                {
                    [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"errorAlert" title:@"Error en el pago" andDetail:error.userInfo[@"error"] inView:nil];
                }
            }];
        }
    }];
}

//---------------------------------------------------------------------

#pragma mark - UIVieController Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //-------------------------------------------
    
    self.dataSource = [NSMutableArray arrayWithObjects:@{@"cellType" : ADD_CELL_TYPE}, nil];
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------------------------------------------------

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Getting info cell from data source
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    NSString *cellIdenfier = ITEM_CELL_TYPE;
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        cellIdenfier = ADD_CELL_TYPE;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:cellIdenfier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        NSDictionary *newItemCell = @{@"cellType" : ITEM_CELL_TYPE};
        [self.dataSource insertObject:newItemCell atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *infoCell = self.dataSource[indexPath.row];
    
    if ([ADD_CELL_TYPE isEqualToString:infoCell[@"cellType"]])
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSDictionary *newItemCell = @{@"cellType" : ITEM_CELL_TYPE};
        [self.dataSource insertObject:newItemCell atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
