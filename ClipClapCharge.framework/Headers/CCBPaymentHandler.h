//
//  CCBPaymentHandler.h
//  ClipClapCharge
//
//  Created by Humberto Cetina on 1/20/16.
//  Copyright © 2016 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CCBilleteraPaymentErrorType) {
    
    kCCBilleteraPaymentErrorTypeRejected = 1,
    kCCBilleteraPaymentErrorTypeFailed = 2
};

@class CCBPayment;
@interface CCBPaymentHandler : NSObject

/**
 *  NSString object that store the mandatory secret key used to commit the payment.
 */
@property (copy, nonatomic) NSString *secretkey;

/**
 *  The URL Scheme or Universal Link you want the ClipClapCharge Framework to execute when the payment it's done.
 */
@property (copy, nonatomic) NSString *urlSchemeOrUniversalLinkCallback;

/**
 *  ClipClapCharge No Documentation
 */
@property (strong, nonatomic) CCBPayment *payment;

/**
 *  Returns the singleton object of this class
 */
+ (CCBPaymentHandler*) shareInstance;

/**
 *  ClipClapCharge No Documentation
 */
- (BOOL) handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication andSuccessfulWhenKilledBlock:(void (^)(BOOL succeeded, NSError *error))successBlock;

/**
 *  ClipClapCharge No Documentation
 */
- (void) getPaymentTokenWithBlock:(void (^)(NSString *token, NSError *error))successCallback;

/**
 *  ClipClapCharge No Documentation
 */
- (void) commitPaymentWithToken:(NSString *)token andBlock:(void (^)(BOOL succeeded, NSError *error))successCallback;

@end
