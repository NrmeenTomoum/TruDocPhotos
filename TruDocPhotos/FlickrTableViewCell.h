//
//  FlickrTableViewCell.h
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/25/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
