//
//  NewUserViewController.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "NewUserViewController.h"
#import "GroupCell.h"
#import "Group.h"
#import "HomeViewController.h"

@interface NewUserViewController () <UITableViewDelegate, UITableViewDataSource, GroupCellDelegate>

@property (strong, nonatomic) NSMutableArray *groupArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchGroups];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchGroups {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query includeKey:@"name"];
    [query orderByDescending:@"name"];
    query.limit = 20;
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            self.groupArray = (NSMutableArray *)posts;
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    [cell setCell:self.groupArray[indexPath.row]];
    cell.delegate = self;
    
    return cell;
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.groupArray count];
}

- (IBAction)didTapEnter:(id)sender {
    
    
    self.createdGroup = [Group makeGroup:self.nameField.text withCompletion:^(BOOL succeeded, NSError  * _Nullable error) {
        if (succeeded) {
            NSLog(@"Made group!");
        } else {
            NSLog(@"Error making group: %@", error.localizedDescription);
        }
    }];
    
    [self.createdGroup addMember:self.createdGroup withUser:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"added user to group");
        } else {
            NSLog(@"Error adding user to group: %@", error.localizedDescription);
        }
    }];
    
    [self performSegueWithIdentifier:@"newToHomeSegue" sender:self.createdGroup];
    
}

- (void)selectCell:(GroupCell *)groupCell didSelect:(Group *)group {
    [self performSegueWithIdentifier:@"newToHomeSegue" sender:group];
}





#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    
}
*/





@end