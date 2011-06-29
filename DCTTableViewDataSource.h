//
//  DCTTableViewDataSource.h
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 30/05/2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCTTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UIViewController *viewController;
- (void)reloadData;

@end
