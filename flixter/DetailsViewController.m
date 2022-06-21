//
//  DetailsViewController.m
//  flixter
//
//  Created by Abigail Shilts on 6/20/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movImage;
@property (weak, nonatomic) IBOutlet UILabel *movRelease;
@property (weak, nonatomic) IBOutlet UILabel *movTitle;
@property (weak, nonatomic) IBOutlet UILabel *movDescrip;
@property (weak, nonatomic) IBOutlet UILabel *movRating;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movRelease.text = self.passedData[@"release_date"];
    self.movTitle.text = self.passedData[@"original_title"];
    self.movDescrip.text = self.passedData[@"overview"];
    self.movTitle.text = self.passedData[@"original_title"];
    self.movRating.text = [NSString stringWithFormat:@"%@", self.passedData[@"vote_average"]];
    
    NSString *link = self.passedData[@"poster_path"];
    NSString *location = @"https://image.tmdb.org/t/p/w92/";
    
    NSString *path = [location stringByAppendingString:link];
    
    NSURL *url = [NSURL URLWithString:path];
    
    [self.movImage setImageWithURL:url];

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
