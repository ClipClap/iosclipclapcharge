//
//  HUDHandler.h
//  ClipClapCine_2
//
//  Created by Humberto Cetina on 1/20/16.
//  Copyright © 2016 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface HUDHandler : NSObject

+ (HUDHandler*) shareInstance;
- (void) showHUDWithTitle:(NSString *)title inView:(UIView *)view;
- (void) showHUDWithImageName:(NSString *)imageName andTitle:(NSString *)title inView:(UIView *)view;
- (void) showHUDWithImageName:(NSString *)imageName title:(NSString *)title andDetail:(NSString *)detail inView:(UIView *)view;

- (void) showHUDTouchDismissWithImageName:(NSString *)imageName andTitle:(NSString *)title inView:(UIView *)view;
- (void) showHUDTouchDismissWithImageName:(NSString *)imageName title:(NSString *)title andDetail:(NSString *)detail inView:(UIView *)view;
- (void) showHUDTouchDismissWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   detail:(NSString *)detail
                                   inView:(UIView *)view
                                 andBlock:(void (^)(BOOL succeeded))successCallback;

- (void) showHUDSucceededWithTitle:(NSString *)title inView:(UIView *)view;
- (void) showHUDWithMakingChangesMessageInView:(UIView *)view;
- (void) showHUDWithChangesDoneMessageInView:(UIView *)view;

- (void) hideHUDWidthDelay:(float)delay;
- (void) hideHUD;
@end
