//
//  DetailsViewController.m
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/23/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import "DetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+WebCache.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOfLargePhoto;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfPhoto;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[_flickrPhoto photoId]);
    UIImageView * imageView = [[UIImageView alloc] init];
    
    NSString* stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg",  [_flickrPhoto farm],[_flickrPhoto server] ,[_flickrPhoto photoId], [_flickrPhoto secret] ];
    NSLog(@"%@", stringURL);
    [imageView sd_setShowActivityIndicatorView:YES];
    [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageView sd_setImageWithURL: [NSURL URLWithString:stringURL]];
    _imageOfLargePhoto.image = imageView.image;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) getInfoOfPhoto
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true;
    NSLog(@"start");
     NSString* urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=37e7bee9d9eca6451915a5bb1b2b284f&photo_id=%@&format=json&nojsoncallback=1&auth_token=72157700198275344-e97779aa6073761d&api_sig=48fd195aab5004215bd9eab772f569fc",  [_flickrPhoto photoId] ];
    NSURL *url = [NSURL URLWithString:urlString];
//    
//    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSError *localError = nil;
//        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//        if (localError != nil) {
//            NSLog(@"ERRor load from server %@ ",localError);
//            return;
//        }
//        NSDictionary *results = [parsedObject valueForKey:@"photos"];
//        NSArray * arrayOfPhoto = [results valueForKey:@"photo"];
//        for (NSDictionary *photoOfJson in arrayOfPhoto) {
//            Photo * photo = [[Photo alloc] init];
//            [photo setPhotoId:[photoOfJson valueForKey:@"id"]];
//            [photo setTitle:[photoOfJson valueForKey:@"title"]];
//            [photo setFarm:[photoOfJson valueForKey:@"farm"]];
//            [photo setSecret:[photoOfJson valueForKey:@"secret"]];
//            [photo setServer:[photoOfJson valueForKey:@"server"]];
//            NSLog(@" %@",photo.photoId);
//            [self->tableData addObject:photo];
//        }
//        NSLog(@"tableData.count %lu", (unsigned long)self->tableData.count);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
//            [self.tableView reloadData];
//        });
//    }] resume];
    
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
