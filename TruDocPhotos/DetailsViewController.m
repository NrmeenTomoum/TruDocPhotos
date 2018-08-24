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
#import "Constant.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfLargePhoto;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOfPhoto;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[_flickrPhoto photoId]);
    UIImageView * imageView = [[UIImageView alloc] init];
    
    NSString* stringURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg",  [_flickrPhoto farm],[_flickrPhoto server] ,[_flickrPhoto photoId], [_flickrPhoto secret] ];
    [_loader startAnimating];
    [imageView sd_setImageWithURL: [NSURL URLWithString:stringURL]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:stringURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [imageView sd_setShowActivityIndicatorView:false];
        self.imageOfLargePhoto.image = imageView.image;
        [self->_loader stopAnimating];
    }];
    [self getInfoOfPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) getInfoOfPhoto
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true;
    NSString* urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", SERVICE_APIKEY_URL ,[_flickrPhoto photoId] ];
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        if (localError != nil) {
            NSLog(@"ERRor load from server %@ ",localError);
            return;
        }
        NSDictionary *results = [parsedObject valueForKey:@"photo"];
        NSDictionary *photoInfo = [results valueForKey:@"description"];
        NSString *description = [photoInfo objectForKey:@"_content"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
            [self.descriptionOfPhoto setText: description];
        });
    }] resume];
    
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
