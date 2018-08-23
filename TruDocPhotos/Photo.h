//
//  Photo.h
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/23/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong,nonatomic) NSString *photoId;
@property (strong,nonatomic) NSString *secret;
@property (strong,nonatomic) NSString *server;
@property (strong,nonatomic) NSString *farm;
@property (strong,nonatomic) NSString *title;
@end
