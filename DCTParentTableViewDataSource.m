//
//  DCTParentTableViewDataSource.m
//  Issues
//
//  Created by Daniel Tull on 20.08.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTParentTableViewDataSource.h"

@interface DCTParentTableViewDataSource ()
- (id<DCTParentTableViewDataSource>)dctInternal_ptvdsSelf;
@end

@implementation DCTParentTableViewDataSource

@synthesize tableView;
@synthesize parent;

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	for (id<DCTTableViewDataSource> ds in self.dctInternal_ptvdsSelf.childTableViewDataSources)
		[ds reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	return [ds objectAtIndexPath:indexPath];
}

- (Class<DCTTableViewCell>)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	return [ds cellClassAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	section = [self.dctInternal_ptvdsSelf dataSectionForTableViewSection:section];
	
	return [ds tableView:tv numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	return [ds tableView:tv cellForRowAtIndexPath:indexPath];
}

#pragma mark Optional

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	section = [self.dctInternal_ptvdsSelf dataSectionForTableViewSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	return [ds tableView:tv titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	section = [self.dctInternal_ptvdsSelf dataSectionForTableViewSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	return [ds tableView:tv titleForFooterInSection:section];
}

#pragma mark Editing

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return NO;
	
	return [ds tableView:tv canEditRowAtIndexPath:indexPath];
}

#pragma mark Moving/reordering

- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return NO;
	
	return [ds tableView:tv canMoveRowAtIndexPath:indexPath];
}

#pragma mark  Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return;
	
	[ds tableView:tv commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:sourceIndexPath];
	NSIndexPath *dsSourceIndexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:sourceIndexPath];
	NSIndexPath *dsDestinationIndexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:sourceIndexPath];
	
	id<DCTTableViewDataSource> ds2 = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:destinationIndexPath];
	NSIndexPath *ds2SourceIndexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:sourceIndexPath];
	NSIndexPath *ds2DestinationIndexPath = [self.dctInternal_ptvdsSelf dataIndexPathForTableViewIndexPath:destinationIndexPath];
	
	if (![ds respondsToSelector:_cmd] || ![ds2 respondsToSelector:_cmd]) return;
	
	[ds tableView:tv moveRowAtIndexPath:dsSourceIndexPath toIndexPath:dsDestinationIndexPath];
	[ds2 tableView:tv moveRowAtIndexPath:ds2SourceIndexPath toIndexPath:ds2DestinationIndexPath];
}

- (id<DCTParentTableViewDataSource>)dctInternal_ptvdsSelf {
	
	if ([self conformsToProtocol:@protocol(DCTParentTableViewDataSource)])
		return (id<DCTParentTableViewDataSource>)self;
	
	return nil;
}

@end
