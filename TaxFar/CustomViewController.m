//
//  CustomViewController.m
//  TaxFar
//
//  Created by Daniel No on 11/25/14.
//  Copyright (c) 2014 Eminence Mobile Applications. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *bgImg = [UIImage imageNamed:@"logo"];
    
    
    UIImageView *navigationImage=[[UIImageView alloc]initWithFrame:CGRectMake(-50, 0, 140, 44)];
    navigationImage.image=[UIImage imageNamed:@"logo"];
    
    UIImageView *workaroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView=workaroundImageView;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
