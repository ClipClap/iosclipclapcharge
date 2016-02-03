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

@class  CCBItem;
@interface CCBPayment : NSObject

/**
 *  The total of the payment. (total-tax-tip mode only, in item by item mode this is always 0)
 */
@property (nonatomic, readonly) int total;

/**
 *  The tax applied to the payment. (total-tax-tip mode only, in item by item mode this is always 0)
 */
@property (nonatomic, readonly) int tax;

/**
 *  The tip the user will pay. (total-tax-tip mode only, in item by item mode this is always 0)
 */
@property (nonatomic, readonly) int tip;

/**
 *  The description of the payment. (total-tax-tip mode only, in item by item mode this is always 0)
 */
@property (copy, nonatomic, readonly) NSString *totalDescription;

/**
 *  The description of the payment. (total-tax-tip mode only, in item by item mode this is always 0)
 */
@property (copy, nonatomic, readonly) NSString *reference;

//-----------------------------------------------------------------

/**
 *  ClipClapCharge No Documentation
 */
- (instancetype) initWithPaymentReference:(NSString *)reference;

/**
 *  Add a item to
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
- (NSUInteger) itemsCount;

/**
 *  ClipClapCharge No Documentation
 */
- (CCBItem *) itemAtIndex:(NSUInteger)index;

@end
