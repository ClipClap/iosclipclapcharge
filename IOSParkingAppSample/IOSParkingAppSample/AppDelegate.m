//
//  AppDelegate.m
//  PayAndGoSample
//
//  Created by Humberto Cetina on 12/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "AppDelegate.h"
#import <ClipClapCharge/ClipClapCharge.h>
#import "HUDHandler.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Setting my unirversal linking to enable Billetera App to send me callback parameters about the status of the payment
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        [CCBPaymentHandler shareInstance].urlSchemeOrUniversalLinkCallback = @"YOUR_UNIVERSAL_LINK_CONFIGURE_IN_YOUR_SERVER_FOR_THIS_APP";
    }
    else
    {
        [CCBPaymentHandler shareInstance].urlSchemeOrUniversalLinkCallback = @"YOUR_URL_SCHEME_CONFIGURE_IN_THIS_APP_INFO_LIST"; //This app has currently configured this: IOSParkingAppSample://
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//iOS 8.x.x
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] handleURL:url
                                                                 sourceApplication:sourceApplication
                                                      andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"done" title:@"Pago exitoso" andDetail:@"Pago realizado con éxito, gracias por usar ClipClap Billetera" inView:nil];
        }
        else
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"errorAlert" title:@"Error en el pago" andDetail:error.userInfo[@"error"] inView:nil];
        }
    }];
    
    return didClipClapBilleteraHandle;
}

//iOS 9 o superior si se usa URL SCHEME

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] handleURL:url
                                                                 sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                      andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"done" title:@"Pago exitoso" andDetail:@"Pago realizado con éxito, gracias por usar ClipClap Billetera" inView:nil];
        }
        else
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"errorAlert" title:@"Error en el pago" andDetail:error.userInfo[@"error"] inView:nil];
        }
    }];
    
    return didClipClapBilleteraHandle;
}

//iOS 9 o superior si se usa UNIVERSAL LINK
- (BOOL) application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler{
    
    NSURL *url = userActivity.webpageURL;
    BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] handleURL:url
                                                                 sourceApplication:nil
                                                      andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"done" title:@"Pago exitoso" andDetail:@"Pago realizado con éxito, gracias por usar ClipClap Billetera" inView:nil];
        }
        else
        {
            [[HUDHandler shareInstance] showHUDTouchDismissWithImageName:@"errorAlert" title:@"Error en el pago" andDetail:error.userInfo[@"error"] inView:nil];
        }
    }];
    
    return didClipClapBilleteraHandle;
}

@end
