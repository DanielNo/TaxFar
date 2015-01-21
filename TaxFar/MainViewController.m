//
//  MainViewController.m
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "mySingleton.h"
#import "DeviceHardware.h"

@interface MainViewController (){
    
}

@property (strong,nonatomic) NSString *locationServices;



@end

@implementation MainViewController

@synthesize gpsStatus,authorizationStatus,locationServices,username;


- (IBAction)updateLocation:(id)sender {
    //[shared updateLocation];
}

-(void)logout{
   
    [shared destroyToken];
    [self.navigationController popViewControllerAnimated:YES];
    [shared stopUpdatingLocation];
    
}

-(void)toForeground{
    [gpsStatus setText:shared.locationServices];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toForeground) name:@"toForeground" object:nil];
    NSString *deviceType = [UIDevice currentDevice].model;
    //NSLog(@"DEVICE TYPE %@", deviceType);

    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(logout)];
    
   
    
    
    

    
    UIColor *backgroundColor = [UIColor colorWithRed:(219/255.0) green:(225/255.0) blue:(243/255.0) alpha:1];
    self.view.backgroundColor = backgroundColor;
    shared = [mySingleton sharedInstance];
    [self updateUsername];
    [shared requestAlwaysAuthorization];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkAuthStatus) name:@"authStatusChanged" object:nil];
    
	// Do any additional setup after loading the view.
    [self updateStatus];

    
    
    
    
    
}

-(void)updateUsername{
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    username.text = user;
    
}

-(void)updateStatus{
    [self checkAuthStatus];
    [shared startSignificantLocationUpdates];
    //[shared.locationManager startUpdatingLocation];
}

-(void)checkAuthStatus{
    switch ([CLLocationManager authorizationStatus]) {
        case (kCLAuthorizationStatusNotDetermined):
            authorizationStatus.text = @"Location services not determined for TaxFar. Go to Settings -> Privacy -> Location Services to enable.";
            break;
        case (kCLAuthorizationStatusRestricted):
            authorizationStatus.text = @"Location services restricted for TaxFar. Go to Settings -> Privacy -> Location Services";
            break;
        case (kCLAuthorizationStatusDenied):
            //never checked in authorization
            authorizationStatus.text = @"Location services disabled for TaxFar. Go to Settings -> Privacy -> Location Services";
            break;
        case (kCLAuthorizationStatusAuthorizedAlways):
            authorizationStatus.text = @"TaxFar is now collecting location data in the background. Press the home button on your device to minimize the application.";
            break;

    }
    [shared locationServicesEnabledCheck];
    [gpsStatus setText: shared.locationServices];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //BOOL loccheck = [shared locationCheck];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
