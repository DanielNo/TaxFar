//
//  mySingleton.h
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>



@interface mySingleton : NSObject <CLLocationManagerDelegate>{
    NSUserDefaults *defaults;
    AFHTTPRequestOperationManager *networkManager;
    
}

@property (nonatomic,strong) NSString *locationServices;
@property (nonatomic,strong) NSDateFormatter *dformat;
@property (nonatomic,strong) NSDateComponents *dateComponents;
@property (nonatomic,strong) NSDate *theDate;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSDate *compareDate;  // date for location comparisons
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *deviceModel;
@property (nonatomic,strong) NSString *username;
/*
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) CLPlacemark *placemark;
*/
 
+ (mySingleton*)sharedInstance;
-(void)loginAttemptforUser:(NSString *)user forPassword:(NSString*)pw;
-(void) stopUpdatingLocation;
-(BOOL)isValid:(NSData *)data;
-(void)checkToken:(NSString *)theToken;
-(void)destroyToken;
-(void)createToken;
-(void)startSignificantLocationUpdates;
-(void)createCompareDate;
-(void)initialLaunch;
-(void)secondLaunch;
-(BOOL)compareDates:(NSDate *)savedDate :(NSDate *)currentDate;
-(void)printDate:(NSDate *)date extraInfo:(NSString *) info;
-(BOOL)locationServicesEnabledCheck;
-(BOOL)tokenExists;
-(void)requestAlwaysAuthorization;


@end
