//
//  CCBilleteraPayment.h
//  ClipClapBilleteraPago
//
//  Created by Humberto Cetina on 12/5/15.
//  Copyright © 2015 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CCBilleteraTaxType) {
    
    kCCBilleteraTaxTypeIVARegular= 1,
    kCCBilleteraTaxTypeIVAReducido = 2,
    kCCBilleteraTaxTypeIVAExcento = 3,
    kCCBilleteraTaxTypeIVAExcluido = 4,
    kCCBilleteraTaxTypeConsumoRegular = 5,
    kCCBilleteraTaxTypeConsumoReducido = 6,
    kCCBilleteraTaxTypeIVAAmpliado = 7
};

//-----------------------------------------------------------------

@interface CCBilleteraPayment : NSObject

/**
 *  NSString object that store the mandatory secret key used to commit the payment.
 */
@property (copy, nonatomic) NSString *secretkey;

/**
 *  The total of the payment.
 */
@property (nonatomic, readonly) int total;

/**
 *  The tax applied to the payment.
 */
@property (nonatomic, readonly) int tax;

/**
 *  ClipClapCharge No Documentation
 */
@property (nonatomic, readonly) int tip;

/**
 *  ClipClapCharge No Documentation
 */
@property (copy, nonatomic, readonly) NSString *totalDescription;

/**
 *  ClipClapCharge No Documentation
 */
@property (copy, nonatomic) NSString *universalLinlCallback;

/**
 *  ClipClapCharge No Documentation
 */
@property (copy, nonatomic) NSString *urlSchemeCallback;

//-----------------------------------------------------------------

/**
 *  ClipClapCharge No Documentation
 */
+ (CCBilleteraPayment*) shareInstance;

/**
 *  ClipClapCharge No Documentation
 */
- (void) resetItems;

/**
 *  ClipClapCharge No Documentation
 */
- (void) addItemWithName:(NSString *)name value:(int)value andCount:(int)count;

/**
 *  ClipClapCharge No Documentation
 */
- (void) addItemWithName:(NSString *)name value:(int)value count:(int)count andTaxType:(CCBilleteraTaxType)type;

/**
 *  ClipClapCharge No Documentation
 */
- (void) addTotalWithValue:(int)value tax:(int)tax andDescription:(NSString *)description;

/**
 *  ClipClapCharge No Documentation
 */
- (void) addTotalWithValue:(int)value tax:(int)tax tip:(int)tip andDescription:(NSString *)description;

/**
 *  ClipClapCharge No Documentation
 */
- (void) getPaymentTokenWithBlock:(void (^)(NSString *token, NSError *error))successCallback;

/**
 *  ClipClapCharge No Documentation
 */
- (void) commitPaymentWithToken:(NSString *)token;

@end
