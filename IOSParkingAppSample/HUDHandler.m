//
//  HUDHandler.m
//  ClipClapCine_2
//
//  Created by Humberto Cetina on 1/20/16.
//  Copyright © 2016 My Organization. All rights reserved.
//

#import "HUDHandler.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface HUDHandler () <MBProgressHUDDelegate>
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (copy, nonatomic) void (^completion)(BOOL);
@end


@implementation HUDHandler

+ (HUDHandler*) shareInstance{
    
    static HUDHandler *hudHandler;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        hudHandler = [[super allocWithZone:NULL] init];
    });
    
    return hudHandler;
}

//----------------------------------------------

- (void) createHUDInView:(UIView *)view{
    
    if (!self.HUD)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.HUD = [MBProgressHUD showHUDAddedTo:(view) ? view : appDelegate.window animated:YES];
        self.HUD.delegate = self;
        self.HUD.color = [[UIColor whiteColor] colorWithAlphaComponent:0.93];
        self.HUD.labelColor = [UIColor blackColor];
        self.HUD.detailsLabelColor = [UIColor blackColor];
        self.HUD.activityIndicatorColor = [UIColor blackColor];
        self.HUD.dimBackground = YES;
    }
}


- (void) showHUDWithTitle:(NSString *)title inView:(UIView *)view{
    
    [self showHUDWithImageName:nil title:title andDetail:nil inView:view];
}

- (void) showHUDWithImageName:(NSString *)imageName andTitle:(NSString *)title inView:(UIView *)view{
    
    [self showHUDWithImageName:imageName title:title andDetail:nil inView:view];
}

- (void) showHUDWithImageName:(NSString *)imageName title:(NSString *)title andDetail:(NSString *)detail inView:(UIView *)view{
    
    [self createHUDInView:view];
    
    BOOL isEmpty = ([[imageName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
    
    if (imageName && !isEmpty)
    {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        self.HUD.mode = MBProgressHUDModeCustomView;
    }
    else
    {
        self.HUD.mode = MBProgressHUDModeIndeterminate;
    }
    
    self.HUD.labelText = title;
    self.HUD.detailsLabelText = detail;
}


- (void) showHUDTouchDismissWithImageName:(NSString *)imageName andTitle:(NSString *)title inView:(UIView *)view{
    
    [self showHUDTouchDismissWithImageName:imageName title:title andDetail:nil inView:view];
}

- (void) showHUDTouchDismissWithImageName:(NSString *)imageName title:(NSString *)title andDetail:(NSString *)detail inView:(UIView *)view{
    
    [self showHUDWithImageName:imageName title:title andDetail:detail inView:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(hideHUD) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 999;
    button.frame = self.HUD.frame;
    [self.HUD addSubview:button];
}

- (void) showHUDTouchDismissWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   detail:(NSString *)detail
                                   inView:(UIView *)view
                                 andBlock:(void (^)(BOOL succeeded))successCallback{
    
    [self showHUDTouchDismissWithImageName:imageName title:title andDetail:detail inView:nil];
    self.completion = successCallback;
}

- (void) showHUDSucceededWithTitle:(NSString *)title inView:(UIView *)view{
    
    [self showHUDWithImageName:@"done" title:title andDetail:nil inView:view];
}

- (void) showHUDWithMakingChangesMessageInView:(UIView *)view{
    
    [self showHUDWithTitle:@"Guardando Cambios" inView:view];
}

- (void) showHUDWithChangesDoneMessageInView:(UIView *)view{
    
    [self showHUDSucceededWithTitle:@"Listo" inView:view];
}



- (void) hideHUDWidthDelay:(float)delay{
    
    UIButton *button = (UIButton *)[self.HUD viewWithTag:999];
    [button removeFromSuperview];
    
    [self.HUD hide:YES afterDelay:delay];
    
    if (self.completion)
    {
        self.completion(YES);
        self.completion = nil;
    }
}

- (void) hideHUD{
    
    [self hideHUDWidthDelay:0];
}

//----------------------------------------------

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}


@end
