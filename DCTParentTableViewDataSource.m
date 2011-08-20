//
//  DCTParentTableViewDataSource.m
//  Issues
//
//  Created by Daniel Tull on 20.08.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTParentTableViewDataSource.h"
#import "DCTTableViewDataSource.h"

@implementation DCTParentTableViewDataSource

@synthesize tableView;
@synthesize parent;

#pragma mark - DCTParentTableViewDataSource

- (NSArray *)childTableViewDataSources {
	return nil;
}

- (NSIndexPath *)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource
	   tableViewIndexPathForDataIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (NSInteger)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource
	   tableViewSectionForDataSection:(NSInteger)section {
	return 0;
}

- (BOOL)tableViewDataSourceShouldUpdateCells:(id<DCTTableViewDataSource>)dataSource {
	return NO;
}

- (id<DCTTableViewDataSource>)childDataSourceForIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (id<DCTTableViewDataSource>)childDataSourceForSection:(NSInteger)section {
	return nil;
}

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	for (id<DCTTableViewDataSource> ds in self.childTableViewDataSources)
		[ds reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:indexPath];
	indexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:indexPath];
	return [ds objectAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self childDataSourceForSection:section];
	section = [self childTableViewDataSource:ds tableViewSectionForDataSection:section];
	return [ds tableView:tv numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:indexPath];
	indexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:indexPath];
	return [ds tableView:tv cellForRowAtIndexPath:indexPath];
}

@end
