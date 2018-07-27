//
//  LoginViewController.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.borderWidth = 0.8f;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.signupButton.layer.borderWidth = 0.8f;
    self.signupButton.layer.borderColor = [UIColor grayColor].CGColor;
    UIColor *backgroundColor = [UIColor colorWithRed:0.78 green:0.92 blue:0.75 alpha:1.0];
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    UIColor *lightGreenColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    [self.loginButton setBackgroundColor:backgroundColor];
    self.loginButton.layer.borderColor = backgroundColor.CGColor;
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width /15;
    self.loginButton.clipsToBounds = YES;
    [self.loginButton setTitleColor:darkGreenColor forState:UIControlStateNormal];
    [self.signupButton setBackgroundColor:backgroundColor];
    self.signupButton.layer.borderColor = backgroundColor.CGColor;
    self.signupButton.layer.cornerRadius = self.signupButton.frame.size.width /15;
    self.signupButton.clipsToBounds = YES;
    self.signupButton.titleLabel.textColor = darkGreenColor;
    [self.signupButton setTitleColor:darkGreenColor forState:UIControlStateNormal];
    self.titleLabel.textColor = lightGreenColor;
    self.usernameLabel.textColor = lightGreenColor;
    self.passwordLabel.textColor = lightGreenColor;
    self.orLabel.textColor = lightGreenColor;
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKB {
    [self.view endEditing:YES];
}

+(void)presentAlertWithTitle:(NSString *)title fromViewController:(UIViewController *)parentViewController {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {// handle response here.
    }];
    
    [alertViewController addAction:okAction];
    [parentViewController presentViewController:alertViewController animated:YES completion:nil];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            [LoginViewController presentAlertWithTitle:@"Error logging in" fromViewController:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            NSLog(@"User logged in successfully");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(user[@"groupName"] == nil) {
                [self performSegueWithIdentifier:@"newUserSegue" sender:nil];
            } else {
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }
    }];
}

- (IBAction)didSignup:(id)sender {
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
}


- (IBAction)didLogin:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loginUser];
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
