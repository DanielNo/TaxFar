//
//  AppDelegate.h
//  TaxFar
//
//  Created by Daniel No on 11/20/14.
//  Copyright (c) 2014 Eminence Mobile Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mySingleton;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    mySingleton *shared;
    BOOL isInBackground;
    UIBackgroundTaskIdentifier bgTask;
    NSTimer *timer;
}

@property (strong, nonatomic) UIWindow *window;

@end
