//
//  DCTParentTableViewDataSource.h
//  Issues
//
//  Created by Daniel Tull on 20.08.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

@protocol DCTTableViewDataSource;
@protocol DCTParentTableViewDataSource <DCTTableViewDataSource>

@property (nonatomic, readonly) NSArray *childTableViewDataSources;

- (NSIndexPath *)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewIndexPathForDataIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewSectionForDataSection:(NSInteger)section;

- (id<DCTTableViewDataSource>)childDataSourceForSection:(NSInteger)section;
- (id<DCTTableViewDataSource>)childDataSourceForIndexPath:(NSIndexPath *)indexPath;

- (BOOL)tableViewDataSourceShouldUpdateCells:(id<DCTTableViewDataSource>)dataSource;

@end

@interface DCTParentTableViewDataSource : NSObject <DCTParentTableViewDataSource>

@end
