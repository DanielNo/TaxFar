//
//  MainViewController.h
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@class mySingleton;
@interface MainViewController : CustomViewController{
    mySingleton *shared;
   
    
}

@property (weak, nonatomic) IBOutlet UILabel *gpsStatus;
@property (weak,nonatomic) IBOutlet UILabel *authorizationStatus;
@property (weak, nonatomic) IBOutlet UILabel *username;


- (IBAction)updateLocation:(id)sender;

-(void)logout;


@end
