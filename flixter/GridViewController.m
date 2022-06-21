//
//  GridViewController.m
//  flixter
//
//  Created by Abigail Shilts on 6/20/22.
//

#import "GridViewController.h"
#import "CustomSection.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    
    [self fetchMovies];
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0aaad3f975c8116c667007769d7f26c0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             // sets movies to hold data
             self.movies = dataDictionary[@"results"];
               
             for (int i = 0; i < [self.movies count]; i++)
               NSLog(@"%@", self.movies[i]);
               [self.collectionView reloadData];
           }
       }];
    [task resume];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
        CustomSection *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mySection" forIndexPath:indexPath];

        // creates url for poster image
        NSString *link = self.movies[indexPath.row][@"poster_path"];
        NSString *location = @"https://image.tmdb.org/t/p/w92/";

        NSString *path = [location stringByAppendingString:link];

        NSURL *url = [NSURL URLWithString:path];

        [cell.posterImg setImageWithURL:url];

        return cell;
    }

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.movies.count;
}



@end






