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
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorIcon;

@end

@implementation MovieViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 135;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    // Do any additional setup after loading the view.
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=0aaad3f975c8116c667007769d7f26c0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection appears to be offline." preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction *buttonTryAgain = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self fetchMovies];
                }];
               
               [controller addAction:buttonTryAgain];
               [self presentViewController:controller animated:YES completion:nil];
               

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               //NSLog(@"%@", dataDictionary);
               
             self.movies = dataDictionary[@"results"];
               
             for (int i = 0; i < [self.movies count]; i++)
                NSLog(@"%@", self.movies[i]);
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    [task resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"*********************************");
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    //forIndexPath:indexPath
    //NSDictionary *movie = self.movies[indexPath.row];
    //NSArray *movie = [self.movies[indexPath.row] componentsSeparatedByString:@", "];
   
    cell.titleLabel.text = self.movies[indexPath.row][@"original_title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"overview"];
    NSString *link = self.movies[indexPath.row][@"poster_path"];
    NSString *location = @"https://image.tmdb.org/t/p/w92/";
    
    NSString *path = [location stringByAppendingString:link];
    
    NSURL *url = [NSURL URLWithString:path];
    
    [cell.posterImageView setImageWithURL:url];
    
    //NSDictionary *movie = self.movies[indexPath.row];
   // cell.titleLabel.text = movie[@"title"];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"????????????????????");
    return self.movies.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
    NSDictionary *dataToPass = self.movies[senderIndex.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    
    detailVC.passedData = dataToPass;
    
    //Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
}


@end
