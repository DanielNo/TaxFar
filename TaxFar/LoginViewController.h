//
//  LoginViewController.h
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@class mySingleton,DNActivityIndicator;

@interface LoginViewController : CustomViewController <UITextFieldDelegate,UIAlertViewDelegate>{
    
    mySingleton *shared;
    NSUserDefaults *defaults;
    
}


@property (strong,nonatomic) NSString *bSaveUsername;
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak,nonatomic) IBOutlet UIButton *loginBtn;

@property (strong,nonatomic) UILabel *rememberAccount;
@property (strong,nonatomic) DNActivityIndicator *spinner;


- (IBAction)authenticate:(id)sender;

@end
