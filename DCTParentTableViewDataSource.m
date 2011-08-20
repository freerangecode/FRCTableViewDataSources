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

#pragma mark Optional

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self childDataSourceForSection:section];
	section = [self childTableViewDataSource:ds tableViewSectionForDataSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	return [ds tableView:tv titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self childDataSourceForSection:section];
	section = [self childTableViewDataSource:ds tableViewSectionForDataSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	return [ds tableView:tv titleForFooterInSection:section];
}

#pragma mark Editing

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:indexPath];
	indexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return YES;
	
	return [ds tableView:tv canEditRowAtIndexPath:indexPath];
}

#pragma mark Moving/reordering

- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:indexPath];
	indexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return NO;
	
	return [ds tableView:tv canMoveRowAtIndexPath:indexPath];
}

#pragma mark  Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:indexPath];
	indexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return;
	
	[ds tableView:tv commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	id<DCTTableViewDataSource> ds = [self childDataSourceForIndexPath:sourceIndexPath];
	NSIndexPath *dsSourceIndexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:sourceIndexPath];
	NSIndexPath *dsDestinationIndexPath = [self childTableViewDataSource:ds tableViewIndexPathForDataIndexPath:sourceIndexPath];
	
	id<DCTTableViewDataSource> ds2 = [self childDataSourceForIndexPath:destinationIndexPath];
	NSIndexPath *ds2SourceIndexPath = [self childTableViewDataSource:ds2 tableViewIndexPathForDataIndexPath:sourceIndexPath];
	NSIndexPath *ds2DestinationIndexPath = [self childTableViewDataSource:ds2 tableViewIndexPathForDataIndexPath:destinationIndexPath];
	
	if (![ds respondsToSelector:_cmd] || ![ds2 respondsToSelector:_cmd]) return;
	
	[ds tableView:tv moveRowAtIndexPath:dsSourceIndexPath toIndexPath:dsDestinationIndexPath];
	[ds2 tableView:tv moveRowAtIndexPath:ds2SourceIndexPath toIndexPath:ds2DestinationIndexPath];
}

@end
