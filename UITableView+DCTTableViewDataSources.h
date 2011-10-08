//
//  UITableView+DCTTableViewDataSources.h
//  Issues
//
//  Created by Daniel Tull on 08.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (DCTTableViewDataSources)
- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellSubclass;
@end
