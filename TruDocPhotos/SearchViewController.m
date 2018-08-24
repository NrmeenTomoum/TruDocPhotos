//
//  ViewController.m
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/21/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+WebCache.h"
#import "Photo.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
{
    NSMutableArray *searchResults;
    
}
// MARK:  LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    searchResults = [[NSMutableArray alloc]init];
    self.searchBar.delegate = self;
}

-(void) fetchPhotos :(NSString*) searchText
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true;
    NSLog(@"start");
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=37e7bee9d9eca6451915a5bb1b2b284f&tags=New e&per_page=10&format=json&nojsoncallback=1
    NSString  * replacement =  [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString * escapedSearchText = [replacement stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet];
    NSString* stringURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=10&format=json&nojsoncallback=1",@"37e7bee9d9eca6451915a5bb1b2b284f", escapedSearchText];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSLog(@"stringURL %@",stringURL);
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        if (localError != nil) {
            NSLog(@"ERRor load from server %@ ",localError);
            return;
        }
        NSDictionary *results = [parsedObject valueForKey:@"photos"];
        NSMutableArray * arrayOfPhoto = [results valueForKey:@"photo"];
        for (NSDictionary *photoOfJson in arrayOfPhoto) {
            Photo * photo = [[Photo alloc] init];
            [photo setPhotoId:[photoOfJson valueForKey:@"id"]];
            [photo setTitle:[photoOfJson valueForKey:@"title"]];
            [photo setFarm:[photoOfJson valueForKey:@"farm"]];
            [photo setSecret:[photoOfJson valueForKey:@"secret"]];
            [photo setServer:[photoOfJson valueForKey:@"server"]];
            NSLog(@" %@",photo.photoId);
            [self->searchResults addObject:photo];
        }
        NSLog(@"tableData.count %lu", (unsigned long)self->searchResults.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
            //  [self.tableView reloadData];
            [self.tableView reloadData];
        });
    }] resume];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// MARK - Segue
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "PhotoSegue" {
//        let photoViewController = segue.destination as! PhotoViewController
//        let selectedIndexPath = tableView.indexPathForSelectedRow
//        photoViewController.flickrPhoto = photos[selectedIndexPath!.row]
//    }
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"PhotoSegue"] )
    {
        DetailsViewController * photoViewController =  [segue destinationViewController
                                                        ] ;
        NSIndexPath* selectedIndexPath = [_tableView indexPathForSelectedRow];
        [photoViewController setFlickrPhoto:searchResults[selectedIndexPath.row]];
    }
    
}
// MARK:  tableView
// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"PhotoSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] title];
    UIImageView * imageView = [[UIImageView alloc] init];
    // for larger photo: --  _b
    NSString* stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg",  [[searchResults objectAtIndex:indexPath.row] farm],[[searchResults objectAtIndex:indexPath.row] server] ,[[searchResults objectAtIndex:indexPath.row] photoId], [[searchResults objectAtIndex:indexPath.row] secret] ];
    
    [imageView sd_setShowActivityIndicatorView:true];
    [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageView sd_setImageWithURL: [NSURL URLWithString:stringURL]];
    
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageHighPriority];
    cell.imageView.image = imageView.image;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.;
}
// MARK:  searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar text].length == 0)
    {
    }
    else
    {
        [searchBar resignFirstResponder];
        [searchResults removeAllObjects];
        [self fetchPhotos:[searchBar text]];
    }
    
    
}


@end
