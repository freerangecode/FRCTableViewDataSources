//
//  UITableView+DCTTableViewDataSources.h
//  Issues
//
//  Created by Daniel Tull on 08.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DCTTableViewDataSource;




@interface UITableView (DCTTableViewDataSources)
- (void)dct_logTableViewDataSources;

- (NSInteger)dct_convertSection:(NSInteger)section fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource;

- (NSIndexPath *)dct_convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource;

- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellSubclass;






@end
