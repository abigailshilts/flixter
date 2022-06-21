//
//  MovieViewController.m
//  flixter
//
//  Created by Abigail Shilts on 6/15/22.
//

#import "MovieViewController.h"
#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"




@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *movies; // Holds data dictionary from API json
@property (weak, nonatomic) IBOutlet UITableView *tableView;  // links to the table view
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorIcon;

@end

@implementation MovieViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 135;  // detirmines row size
    
    // initially populates movies
    [self fetchMovies];
    
    // creates a refresh icon and checks for updates to the api database
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

// obtains json data from api and loads it into movies
- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0aaad3f975c8116c667007769d7f26c0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               // Creates a pop up alert if there are network issues
               UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection appears to be offline." preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction *buttonTryAgain = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self fetchMovies];
                }];
               
               [controller addAction:buttonTryAgain];
               [self presentViewController:controller animated:YES completion:nil];
               

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             // sets movies to hold data
             self.movies = dataDictionary[@"results"];
               
             for (int i = 0; i < [self.movies count]; i++)
               NSLog(@"%@", self.movies[i]);
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}

// Method for assigning values into cell items
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.movies[indexPath.row][@"original_title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"overview"];
    
    // creates url for poster image
    NSString *link = self.movies[indexPath.row][@"poster_path"];
    NSString *location = @"https://image.tmdb.org/t/p/w92/";
    
    NSString *path = [location stringByAppendingString:link];
    
    NSURL *url = [NSURL URLWithString:path];
    
    [cell.posterImageView setImageWithURL:url];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


#pragma mark - Navigation

// method for sending selected movie's data to DetailsViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
    NSDictionary *dataToPass = self.movies[senderIndex.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    
    detailVC.passedData = dataToPass; // sends data as a dictionary
}


@end
