//
//  DCTTableViewTitledDataSource.h
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTSectionedTableViewDataSource.h"

@interface DCTTableViewTitledDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) DCTSectionedTableViewDataSource *sectionController;

@property (nonatomic, strong) id<UITableViewDataSource> tableViewDataSource;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL greyWhenEmpty;

@end
