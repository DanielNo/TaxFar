//
//  mySingleton.m
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import "mySingleton.h"
#import "AFNetworking.h"
#import "DeviceHardware.h"


#define locationURL @"add_location.json"
#define loginURL @"new_mobile_token.json"
#define validTokenURL @"is_valid_token.json"
#define newTokenURL @"new_mobile_token.json"

#define baseURL [NSURL URLWithString: @"https://agile-ridge-5667.herokuapp.com/"]
static double postRate = 300.0; //secs


static mySingleton* _sharedInstance = nil;

@implementation mySingleton
@synthesize version,deviceModel,username;





#pragma mark --
#pragma mark location

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    //NSLog(@"error : %@",[error localizedDescription]);
}

-(void)postLocation:(CLLocation *)theLoc time:(NSString *)locationTime{
    NSNumber *latitude = [NSNumber numberWithDouble:[theLoc coordinate].latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:[theLoc coordinate].longitude];
    
    NSDictionary *params =
    
    params = @{@"token" : [self token],
               @"latitude" : latitude,
               @"longitude" : longitude,
               @"time" : locationTime,
               @"phone_info" : deviceModel,
               @"app_version" : version
               };
    
    [self printLocation:theLoc time:locationTime];
    
    
    [networkManager POST:locationURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSLog(@"json : %@",responseObject);
       
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error : %@",error);
    }];
    
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    CLLocation *newLocation = [locations lastObject];



    //[self printDate:_compareDate extraInfo:@"Old Loc"];
    //[self printDate:newLocation.timestamp extraInfo:@"New loc"];
    
    NSString *time = [_dformat stringFromDate:newLocation.timestamp];
     _latitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
     _longitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
            NSDictionary *jsonDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:_token, @"token",_latitude,@"latitude",_longitude,@"longitude",time,@"time",nil];
    
    
    
                NSError *error = nil;
    
    
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    bool compared = [self compareDates:_compareDate :newLocation.timestamp];
    

    
    if (compared) {
        //post to server
        [self postLocation:newLocation time:time];
        
        _compareDate = newLocation.timestamp;
        [defaults setObject:_compareDate forKey:@"comparedate"];
        [defaults synchronize];
    }

    
}

//authorization status - app specific rights to use locations services
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case (kCLAuthorizationStatusNotDetermined):
            //NSLog(@"Location Services not determined for Audit App. Go to Settings -> Privacy -> Location Services");
            break;
        case (kCLAuthorizationStatusRestricted):
            //NSLog(@"Location Services restricted for Audit App. Go to Settings -> Privacy -> Location Services");
            break;
        case (kCLAuthorizationStatusDenied):
            //NSLog(@"Location Services disabled for Audit App. Go to Settings -> Privacy -> Location Services");
            break;
        case (kCLAuthorizationStatusAuthorizedAlways):
            //NSLog(@"Now collecting location data, you may minimize the application.");
            break;
            
    }
    
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"authStatusChanged" object:nil];
    //[locationManager startMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"location manager failed with error");
    //TODO check if location services enabled
    //check error code kCLErrorDenied
    
}

-(void)stopUpdatingLocation{
    
    [_locationManager stopMonitoringSignificantLocationChanges];
}

-(void)startSignificantLocationUpdates{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [_locationManager startMonitoringSignificantLocationChanges];
        //NSLog(@"singleton - startsignificantlocationupdates success");
        
    }
    else {
        //NSLog(@"singleton - startsignificantlocationupdates failed");
        
    }
}


-(BOOL)locationServicesEnabledCheck{
    BOOL locServicesCheck = [[_locationManager class]locationServicesEnabled];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toForeground" object:nil];
    if (locServicesCheck) {
        _locationServices = @"Enabled";
        return TRUE;
    }
    else{
        _locationServices = @"Disabled";
        return FALSE;
    }
}


#pragma mark --
#pragma mark login process

-(BOOL)tokenExists{
    if ([defaults objectForKey:@"token"]) {
        return YES;
    }
    else {
        return false;
    }
}

-(void)requestAlwaysAuthorization{
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //NSLog(@"request always authorization");
        [self.locationManager requestAlwaysAuthorization];
    }
}

-(void)checkToken:(NSString *)theToken{

    
    
    
    NSDictionary *tokenDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:theToken,@"token", nil];
    __block NSNumber *validToken = nil;
    [networkManager POST:validTokenURL parameters:tokenDictionary success:^(AFHTTPRequestOperation *operation, id responseObject){
        //NSLog(@"check token response : %@",responseObject);
        NSNumber *tokenValidity =  [responseObject objectForKey:@"valid"];
        validToken = tokenValidity;
        switch ([tokenValidity intValue]) {
            case 0:
                //NSLog(@"token check : invalid");
                break;
            case 1:
                //NSLog(@"token check : valid, restoring session..");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login_success" object:nil];
                break;
                
            default:
                break;
        }
        
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [error localizedDescription];
        
    }];
    
    //return [validToken boolValue];
}

-(void)loginAttemptforUser:(NSString *)userN forPassword:(NSString*)pw{
    //NSLog(@"singleton - login attempt for user");
    
    NSDictionary *params = @{@"username" : userN,
                             @"password" : pw};
    
    __block NSDictionary *response;
    __block NSNumber *loginVal;
    __block NSString *bUsername;
    bUsername = userN;
    
    [networkManager POST:loginURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){

        //NSLog(@"json : %@",responseObject);
        response = (NSDictionary *)responseObject;
        
        
        loginVal =  [responseObject objectForKey:@"success"];
        switch ([loginVal boolValue]) {
            case 0:
                //NSLog(@"invalid login attempt");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login_fail" object:nil];
                break;
            case 1:
                //NSLog(@"valid login attempt");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login_success" object:nil];
                [defaults setObject:[responseObject objectForKey:@"token"] forKey:@"token"];
                [defaults setObject:bUsername forKey:@"username"];
 
                [self createToken];
            default:
                break;
        }
        
        
        //NSLog(@"loginval : %i",[loginVal boolValue]);

        

    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     //NSLog(@"error : %@",error);
    }];
    
    
}


-(void)destroyToken{
    _token = @"";
    //NSLog(@"destroyed token :%@",_token);
    [defaults setObject:_token forKey:@"token"];
    [defaults synchronize];
    
}





-(void)createToken{
    _token = [defaults objectForKey:@"token"];
    //NSLog(@"singleton - created token is : %@",_token);
    [defaults synchronize];
}



#pragma mark --
#pragma mark Singleton Method
+ (mySingleton*)sharedInstance
{
    @synchronized(self)
    {
        if(_sharedInstance == nil)
        {
            _sharedInstance = [[super allocWithZone:NULL] init];
            
        }
    }
    return _sharedInstance;
}



+(id)alloc
{
	@synchronized([mySingleton class])
	{
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
    
    
	return nil;
}

-(void)secondLaunch{
    _compareDate = [defaults objectForKey:@"comparedate"];
    NSDate *compareDateDefaults = [defaults objectForKey:@"comparedate"];
    
    NSString *dateString = [_dformat stringFromDate:compareDateDefaults];
    //NSLog(@"grabbed compare date - %@",dateString);
    
}

-(void)initialLaunch{
    [defaults setBool:FALSE forKey:@"saveuser"];
    [defaults setBool:TRUE forKey:@"initialized"];
    [defaults synchronize];
    [self createCompareDate];
    
}

-(void)printDate:(NSDate *)date extraInfo:(NSString *) info{

    
    NSString *dateString = [_dformat stringFromDate:date];
    NSLog(@"%@ - %@",info,dateString);

}

-(void)printLocation:(CLLocation*)loc time:(NSString *)time{
    NSLog(@"latitude : %f , longitude : %f , time : %@ ",[loc coordinate].latitude, [loc coordinate].longitude, time);
}

-(BOOL)compareDates:(NSDate *)savedDate :(NSDate *)currentDate{
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:savedDate];
    if (secs >= postRate) {
        //NSLog(@"date comparison true");
        //NSLog(@"secs : %f",secs);
        return TRUE;
    }
    else
    {
        //NSLog(@"date comparison false");
        //NSLog(@"secs : %f",secs);
        return FALSE;
    }
}

-(void)createCompareDate{
    [defaults setBool:true forKey:@"initialized"];
    [defaults synchronize];
    
    //TODO print date
    _compareDate = [NSDate date];
    [defaults setObject:_compareDate forKey:@"comparedate"];
    [defaults synchronize];
    //[self printDate:_compareDate extraInfo:@"Created date"];
    
    
  
}

-(void)determineDeviceInfo{
    version = [@"iOS" stringByAppendingString:[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] ];

    NSString *platform = [DeviceHardware platform];
    deviceModel = [DeviceHardware platformType:platform];
}


- (id)init
{
    self = [super init];
    if ( self != nil )
    {
        
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
            
            //[locationManager allowDeferredLocationUpdatesUntilTraveled:2000 timeout:secs];
            //distancefilternone only works with standard location services, not significant
            //locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.activityType = CLActivityTypeOther;
            
            
            networkManager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:baseURL];
            networkManager.requestSerializer = [AFJSONRequestSerializer serializer];
            networkManager.responseSerializer = [AFJSONResponseSerializer serializer];
            [self determineDeviceInfo];
        }
    }
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self tokenExists]) {
        _token = [defaults objectForKey:@"token"];
    }
    _theDate = [NSDate date];
    _dformat = [[NSDateFormatter alloc]init];
    [_dformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_dformat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    return self;
}


@end