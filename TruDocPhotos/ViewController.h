//
//  ViewController.h
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/21/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

