//
//  ViewController.m
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/21/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import "SearchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Photo.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
{
    NSMutableArray *tableData;
    NSMutableArray *searchResults;
    Boolean isFiltered;
}
// MARK:  LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = false;
    tableData = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    [self fetchPhotos];
}

-(void) fetchPhotos
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true;
    NSLog(@"start");
    NSString *urlString=@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=0ca2227e9fab92643f996050288d96fc&per_page=25&page=1&format=json&nojsoncallback=1&auth_token=72157700534836285-7482246e02afbfb7&api_sig=eaf76345497a52068d292ec50c2002bb";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        if (localError != nil) {
            NSLog(@"ERRor load from server %@ ",localError);
            return;
        }
        NSDictionary *results = [parsedObject valueForKey:@"photos"];
        NSArray * arrayOfPhoto = [results valueForKey:@"photo"];
        for (NSDictionary *photoOfJson in arrayOfPhoto) {
            Photo * photo = [[Photo alloc] init];
            [photo setPhotoId:[photoOfJson valueForKey:@"id"]];
            [photo setTitle:[photoOfJson valueForKey:@"title"]];
            [photo setFarm:[photoOfJson valueForKey:@"farm"]];
            [photo setSecret:[photoOfJson valueForKey:@"secret"]];
            [photo setServer:[photoOfJson valueForKey:@"server"]];
            NSLog(@" %@",photo.photoId);
            [self->tableData addObject:photo];
        }
        NSLog(@"tableData.count %lu", (unsigned long)self->tableData.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
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
        //  DetailsViewController * photoViewController =  segue.destinationViewController
        
        //        let selectedIndexPath = tableView.indexPathForSelectedRow
        //                photoViewController.flickrPhoto = photos[selectedIndexPath!.row]
        
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
    
    if (isFiltered == true){
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] title];
        UIImageView * imageView = [[UIImageView alloc] init];
        // for larger photo: --  _b
        NSString* stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg",  [[tableData objectAtIndex:indexPath.row] farm],[[tableData objectAtIndex:indexPath.row] server] ,[[tableData objectAtIndex:indexPath.row] photoId], [[tableData objectAtIndex:indexPath.row] secret] ];
        [imageView sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageHighPriority];        cell.imageView.image = imageView.image;

    } else
    {
        cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] title];
        UIImageView * imageView = [[UIImageView alloc] init];
        // for larger photo: --  _b 
        NSString* stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_q.jpg",  [[tableData objectAtIndex:indexPath.row] farm],[[tableData objectAtIndex:indexPath.row] server] ,[[tableData objectAtIndex:indexPath.row] photoId], [[tableData objectAtIndex:indexPath.row] secret] ];
        [imageView sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageHighPriority];        cell.imageView.image = imageView.image;

      //  cell.imageView.image = [UIImage imageNamed:@"Image"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered == true)
    {
        return [searchResults count];
    }
    return [tableData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.;
}
// MARK:  searchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        isFiltered = false;
    }
    else
    {
        isFiltered = true;
        searchResults = [[NSMutableArray alloc]init];
        for (Photo *photo in tableData ) {
            NSRange dataRange = [[photo title] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (dataRange.location != NSNotFound)
            {
                [searchResults addObject:photo];
            }
        }
    }
    [self.tableView reloadData];
}

@end
