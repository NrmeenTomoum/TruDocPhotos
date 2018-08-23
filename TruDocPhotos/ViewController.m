//
//  ViewController.m
//  TruDocPhotos
//
//  Created by Nermeen Tomoum on 8/21/18.
//  Copyright © 2018 NrmeenTomoum. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *tableData;
    NSMutableArray *searchResults;
    Boolean isFiltered;
}
// MARK:  LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = false;
    self.searchBar.delegate = self;
    tableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK:  tableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (isFiltered == true){
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"Image"];
    } else {
        cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"Image"];
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
        for (NSString *item in tableData) {
            NSRange dataRange = [item rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (dataRange.location != NSNotFound)
            {
                [searchResults addObject:item];
            }
        }
    }
    [self.tableView reloadData];
}

@end
