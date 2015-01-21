//
//  LoginViewController.m
//  AuditApp
//
//  Created by Daniel No on 5/7/13.
//  Copyright (c) 2013 Daniel No. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "mySingleton.h"
#import <QuartzCore/QuartzCore.h>
#import "DNActivityIndicator.h"

@interface LoginViewController (){
    
}
@end


@implementation LoginViewController



@synthesize Username,Password,loginBtn;

#pragma mark --
#pragma mark class methods
- (IBAction)authenticate:(id)sender {
    if ([Username.text compare:@""]==NSOrderedSame) {
        UIAlertView *emptyUsername = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Enter a username" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [emptyUsername show];
    }
    else if([Password.text compare:@""]==NSOrderedSame) {
        UIAlertView *emptyPassword = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Enter a password" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [emptyPassword show];
    }
    else{
        [shared loginAttemptforUser:Username.text forPassword:Password.text];

    }
}
- (IBAction)signupForAccount:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://taxfar.com/signup/"]];
}

-(void)loginSegue{
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    [self.navigationController pushViewController:mainVC animated:NO];
    //[self performSegueWithIdentifier:@"login" sender:self];
    
    
}

-(void)loginFailed{
    UIAlertView *invalidLogin = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Invalid username and password, please try again." delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [invalidLogin show];
}



-(void)setupUI{
    [loginBtn addTarget:self action:@selector(authenticate:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginBtn setTitleColor:[UIColor blackColor]
                       forState:UIControlStateHighlighted];
    loginBtn.layer.cornerRadius = 10; // this value vary as per your desire
    loginBtn.clipsToBounds = YES;

    [[loginBtn layer]setBorderWidth:1.3];
    [[loginBtn layer]setBorderColor:[UIColor colorWithRed:19/255.0f green:143/255.0f blue:198/255.0f alpha:1.0].CGColor];
}


#pragma mark --
#pragma mark view methods


- (void)viewDidLoad
{
    
    DNActivityIndicator *spinner = [[DNActivityIndicator alloc]init];
    //DNActivityIndicator *spinner = [[DNActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    //DNActivityIndicator *spinner = [[DNActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, 60, 60) text:@"Loading.."];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSegue) name:@"login_success" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFailed) name:@"login_fail" object:nil];
    
    Password.delegate = self;
    Username.delegate = self;

    
    
    [self setupUI];
    //UIColor *backgroundColor = [UIColor colorWithRed:(41/255.0) green:(128/255.0) blue:(185/255.0) alpha:1];
    UIColor *backgroundColor = [UIColor colorWithRed:(219/255.0) green:(225/255.0) blue:(243/255.0) alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(219/255.0) green:(225/255.0) blue:(243/255.0) alpha:1];
    self.view.backgroundColor = backgroundColor;
    defaults = [NSUserDefaults standardUserDefaults];
    
    [super viewDidLoad];
    
    shared = [mySingleton sharedInstance];
    if ([shared tokenExists]) {
        [shared checkToken:shared.token];
        //NSLog(@"token exists");
    }
    else{
        //NSLog(@"token doesnt exist");
    }
    
    

    
    
	// Do any additional setup after loading the view, typically from a nib.
}



-(void)viewDidAppear:(BOOL)animated{
    animated = NO;
    //NSLog(@"login - TOKEN : %@",shared.token);
    //NSLog(@"login - USERNAME : %@",Username.text);
    
    /*
    if ([shared checkToken:shared.token]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
     */
}

-(void)viewWillAppear:(BOOL)animated{
        [Username setText:@""];
        [Password setText:@""];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitextfield

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldShouldBeginEditing");
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidBeginEditing");
    /*
    if (textField.tag == 1) {
        textField.text = @"danny";
    }
    if (textField.tag == 2) {
        textField.text = @"dannyboy88";
    }
    */
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   // NSLog(@"textFieldShouldEndEditing");
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
   // NSLog(@"textFieldDidEndEditing");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   // NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 1) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark 
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        Password.text = @"";
    }
}


@end
