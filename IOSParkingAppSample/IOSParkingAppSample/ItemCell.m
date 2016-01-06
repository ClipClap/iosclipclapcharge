//
//  ItemCell.m
//  IOSParkingAppSample
//
//  Created by Humberto Cetina on 1/5/16.
//  Copyright © 2016 My Organization. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell () <UIActionSheetDelegate>
@property (strong, nonatomic) UIResponder *currentResponder;
@end

@implementation ItemCell

#pragma mark - UIView Methods

- (void)awakeFromNib {
   
    [self.taxButton setTitle:@"IVA Regular 16%" forState:UIControlStateNormal];
    self.taxType = kCCBilleteraTaxTypeIVARegular;
}


#pragma mark - UITableViewCell Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - My Methods

- (IBAction) selectTaxAction:(id)sender{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"IVA Excento 0%", @"IVA Excluído 0%", @"IVA Reducido 5%", @"IVA Regular 16%", @"IVA Ampliado 20%", @"Consumo Reducido 4%", @"Consumo Regular 8%", nil];
    
    [popup showInView:self];
    
}

- (void) goToNextTexField{
    
    if ([self.currentResponder isEqual:self.itemName])
    {
        [self.itemPrice becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemPrice])
    {
        [self.itemCount becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemCount])
    {
        [self.itemName becomeFirstResponder];
    }
}

- (void) goToPreviousTexField{
    
    if ([self.currentResponder isEqual:self.itemName])
    {
        [self.itemCount becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemPrice])
    {
        [self.itemName becomeFirstResponder];
    }
    else if ([self.currentResponder isEqual:self.itemCount])
    {
        [self.itemPrice becomeFirstResponder];
    }
}

- (void) hideKeyboard{
    
    [self endEditing:YES];
}


#pragma mark - UIActionSheetDelegate Methods

- (void) actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (popup.cancelButtonIndex != buttonIndex)
    {
        switch (buttonIndex) {
            case 0:
                [self.taxButton setTitle:@"IVA Excento 0%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeIVAExcento;
                break;
            case 1:
                [self.taxButton setTitle:@"IVA Excluído 0%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeIVAExcluido;
                break;
            case 2:
                [self.taxButton setTitle:@"IVA Reducido 5%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeIVAReducido;
                break;
            case 3:
                [self.taxButton setTitle:@"IVA Regular 16%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeIVARegular;
                break;
            case 4:
                [self.taxButton setTitle:@"IVA Ampliado 20%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeIVAAmpliado;
                break;
            case 5:
                [self.taxButton setTitle:@"Consumo Reducido 4%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeConsumoReducido;
                break;
            case 6:
                [self.taxButton setTitle:@"Consumo Regular 8%" forState:UIControlStateNormal];
                self.taxType = kCCBilleteraTaxTypeConsumoRegular;
                break;
        }
    }
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
    
    if (textField.text.length > 0 && [textField isEqual:self.itemPrice])
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && [textField isEqual:self.itemPrice])
    {
        NSString *numberFormatted = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[textField.text doubleValue]]
                                                                     numberStyle:NSNumberFormatterDecimalStyle];
        
        textField.text = [NSString stringWithFormat:@"$%@", numberFormatted];
    }
}

@end
