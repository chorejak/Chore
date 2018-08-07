//
//  RepeatChoreViewController.m
//  Chore
//
//  Created by Alice Park on 7/31/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "RepeatChoreViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "LoginViewController.h"
#import "AddChoreViewController.h"

@interface RepeatChoreViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *repeating;
@property (nonatomic, strong) NSString *weekday;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UIViewController *addChoreVC;


@end

@implementation RepeatChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"EEEE"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.repeating = @"Daily";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didChangeStartDate:(id)sender {
    self.startDate = self.startDatePicker.date;
    self.weekday = [self.formatter stringFromDate:self.startDate];
    [self.pickerView reloadAllComponents];
}

- (IBAction)didChangeEndDate:(id)sender {
    self.endDate = self.endDatePicker.date;
}

- (IBAction)didTapSave:(id)sender {
    if(self.startDate == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select a start date" fromViewController:self];
    }
    if(self.endDate == nil) {
        [LoginViewController presentAlertWithTitle:@"Please select an end date" fromViewController:self];
    }
    if ([self.startDate compare:self.endDate] == NSOrderedDescending) {
        NSLog(@"here");
        [LoginViewController presentAlertWithTitle:@"Start date must occur before end date" fromViewController:self];
    }
    self.weekday = [self.formatter stringFromDate:self.startDate];
    [self.delegate updateDeadline:self.startDate withEndDate:self.endDate withFrequency:self.repeating];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch(row) {
        case 0:
            title = @"Daily";
            break;
        case 1:
            if(self.weekday == nil) {
                title = @"Weekly";
            } else {
                title = [NSString stringWithFormat:@"Weekly on %@", self.weekday];
            }
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row == 0) {
        self.repeating = @"Daily";
    } else {
        self.repeating = self.weekday;
    }
}
- (IBAction)onTapCancel:(id)sender {
    //[self presentedViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
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