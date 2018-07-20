//
//  ChoreDetailsViewController.m
//  Chore
//
//  Created by Jonathan Cabrera on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ChoreDetailsViewController.h"
#import "ProfileViewController.h"
#import "ChoreInformationViewController.h"


@interface ChoreDetailsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ChoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChoreDetails];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];

}

- (void)viewDidAppear:(BOOL)animated{
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapeDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setChoreDetails {
    self.userNameLabel.text = self.userName;
    self.choreNameLabel.text = self.chore.name;
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@", self.chore.deadline];
    self.pointLabel.text = [NSString stringWithFormat: @"%d", self.chore.points];
    self.informationLabel.text = self.chore.info;
    self.chorePic.file = self.chore.photo;
    [self.chorePic loadInBackground];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTapAddPic:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Choose a photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [pictureViewController addAction:cameraAction];
    [pictureViewController addAction:galleryAction];
    [pictureViewController addAction:cancelAction];
    
    [self presentViewController:pictureViewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.photo = resizedImage;
    [self.addPictureButton setImage:resizedImage forState:UIControlStateNormal];
    
    if(self.photo != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.photo);
        self.chore.photo = [PFFile fileWithData:imageData];
        [self.chore saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"Saved edits!");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    }
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}




@end
