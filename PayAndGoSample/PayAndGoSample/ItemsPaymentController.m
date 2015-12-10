//
//  ViewController.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ItemsPaymentController.h"
#import <ClipClapCharge/ClipClapCharge.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//---------------------------------------------------------------------

#define ADD_CELL_TYPE @"AddItemCell"
#define ITEM_CELL_TYPE @"ItemCell"

#define NAME_TAG 111
#define PRICE_TAG 222
#define COUNT_TAG 333

//---------------------------------------------------------------------

@interface ItemsPaymentController ()
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

//---------------------------------------------------------------------

@implementation ItemsPaymentController

- (IBAction)payAction:(id)sender {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
    self.navigationItem.title = @"Pagando";
    
    //------------------------------------------------------------------
    
    BOOL isDevelopment = [[NSUserDefaults standardUserDefaults] boolForKey:@"ClipClapChargeDevelopment"];
    
    //Initializing the payment object with the mandatory secret key
    if (isDevelopment)
    {
        [CCBilleteraPayment shareInstance].secretkey = @"MIIwwHc8ksK8AfwUcWJC"; //Development
    }
    else
    {
        [CCBilleteraPayment shareInstance].secretkey = @"pKFe1P2iYw6z73srBDBx"; //production
    }
    
    //Setting my unirversal linking to enable Billetera App to send me callback parameters about the status of the payment
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        [CCBilleteraPayment shareInstance].universalLinlCallback = @"";
    }
    else
    {
        [CCBilleteraPayment shareInstance].urlSchemeCallback = @"PayAndGoSample://";
    }
    
    //Iterating all the cell to get the items information
    for (int i = 0; i < self.dataSource.count - 1; i++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
     
        UITextField *itemName = [cell.contentView viewWithTag:NAME_TAG];
        UITextField *itemPrice = [cell.contentView viewWithTag:PRICE_TAG];
        UITextField *itemCount = [cell.contentView viewWithTag:COUNT_TAG];
        
        //Adding the item information to the payment object
        [[CCBilleteraPayment shareInstance] addItemWithName:itemName.text
                                                      value:[itemPrice.text doubleValue]
                                                      count:[itemCount.text doubleValue]
                                                 andTaxType:kCCBilleteraTaxTypeIVARegular];
    }
    
    //Getting the payment token to later commit the payment
    [[CCBilleteraPayment shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
        
        if (error)
        {
            //Logging the error, but the error must be shown to the user gracefully
        }
        else
        {
            [activityIndicator startAnimating];
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.title = @"Pagando";
            
            //Commiting the payment with the retreive payment token
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
//    //Iterating all the cell to get the items information
//    for (int i = 0; i < self.dataSource.count - 1; i++)
//    {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        
//        UITextField *itemName = [cell.contentView viewWithTag:NAME_TAG];
//        UITextField *itemPrice = [cell.contentView viewWithTag:PRICE_TAG];
//        UITextField *itemCount = [cell.contentView viewWithTag:COUNT_TAG];
//        
//        //Adding the item information to the payment object
//        [[CCBilleteraPayment shareInstance] addItemWithName:itemName.text                   //The name of the item
//                                                      value:[itemPrice.text doubleValue]    //The price of the item
//                                                      count:[itemCount.text doubleValue]    //The count of the same item
//                                                 andTaxType:kCCBilleteraTaxTypeIVARegular]; //The tax type (IVA Regular, IVA Reducido, Cosumo regular, etc)
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

    return 60;
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
