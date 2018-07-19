//
//  ChoreInformationViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//  blash

#import "ChoreInformationViewController.h"
#import "ChoreDetailsViewController.h"
#import "ChoreInformationCell.h"

@interface ChoreInformationViewController () <UITableViewDelegate, UITableViewDataSource, ChoreInformationCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray<Chore *> *chores;

@end

@implementation ChoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchChores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchChores {
    PFQuery *query = [PFQuery queryWithClassName:@"Chore"];
    [query orderByDescending:@"name"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.chores = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChoreInformationCell *choreCell = [tableView dequeueReusableCellWithIdentifier:@"ChoreInformationCell" forIndexPath:indexPath];
    [choreCell setCell:self.chores[indexPath.row]];
    choreCell.delegate = self;
    
    return choreCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chores.count;
}

- (void)seeChore: (ChoreInformationCell *)cell withChore: (Chore *)chore {
    [self performSegueWithIdentifier:@"choreDetailsSegue" sender:chore];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"choreDetailsSegue"]){
        ChoreDetailsViewController *controller = (ChoreDetailsViewController *)segue.destinationViewController;
        controller.chore = sender;
    }
}

@end
