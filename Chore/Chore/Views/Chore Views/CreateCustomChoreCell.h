//
//  CreateCustomChoreCell.h
//  Broombroom
//
//  Created by Alice Park on 8/8/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateCustomChoreCellDelegate;

@interface CreateCustomChoreCell : UITableViewCell

@property (nonatomic, weak) id<CreateCustomChoreCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;

@end

@protocol CreateCustomChoreCellDelegate

- (void)createCustomChore;

@end
