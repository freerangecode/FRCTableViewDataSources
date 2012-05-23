//
//  FRCInterspersedTableViewDataSource.m
//  Tweetville
//
//  Created by Daniel Tull on 23.05.2012.
//  Copyright (c) 2012 Daniel Tull Limited. All rights reserved.
//

#import "FRCInterspersedTableViewDataSource.h"
#import "FRCObjectTableViewDataSource.h"

@implementation FRCInterspersedTableViewDataSource {
	__strong FRCObjectTableViewDataSource *_interspersedDataSource;
}
@synthesize childTableViewDataSource = _childTableViewDataSource;
@synthesize showInterspersedCellOnBottom = _showInterspersedCellOnBottom;
@synthesize showInterspersedCellOnTop = _showInterspersedCellOnTop;

- (id)init {
	if (!(self = [super init])) return nil;
	_interspersedDataSource = [FRCObjectTableViewDataSource new];
	return self;
}

- (void)setInterspersedCellClass:(Class)interspersedCellClass {
	_interspersedDataSource.cellClass = interspersedCellClass;
}
- (Class)interspersedCellClass {
	return _interspersedDataSource.cellClass;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger amount = [self.childTableViewDataSource tableView:tableView numberOfRowsInSection:section];
	amount = (2*amount)-1;
	if (self.showInterspersedCellOnBottom) amount++;
	if (self.showInterspersedCellOnTop) amount++;
	return amount;
}

#pragma mark - FRCParentTableViewDataSource

- (NSArray *)childTableViewDataSources {
	return [NSArray arrayWithObjects:_interspersedDataSource, self.childTableViewDataSource, nil];
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	
	if ([dataSource isEqual:_interspersedDataSource]) {
	
		if (self.showInterspersedCellOnTop)
			return [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
		
		return [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
	}
	
	NSInteger row = 2*indexPath.row;
		
	if (self.showInterspersedCellOnTop) row++;
	
	return [NSIndexPath indexPathForRow:row inSection:indexPath.section];	
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	
	if ([dataSource isEqual:_interspersedDataSource])
		return [NSIndexPath indexPathForRow:0 inSection:0];
	
	NSInteger row = indexPath.row;
	
	if (self.showInterspersedCellOnTop) row--;
	
	row = row/2;
	
	return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (FRCTableViewDataSource *)childTableViewDataSourceForSection:(NSInteger)section {
	return self.childTableViewDataSource;
}

- (FRCTableViewDataSource *)childTableViewDataSourceForIndexPath:(NSIndexPath *)indexPath {
	
	BOOL isEvenRow = (indexPath.row % 2 == 0);
	
	if (self.showInterspersedCellOnTop) isEvenRow = !isEvenRow;
		
	if (isEvenRow) return self.childTableViewDataSource;
		
	return _interspersedDataSource;
}

- (BOOL)childTableViewDataSourceShouldUpdateCells:(FRCTableViewDataSource *)dataSource {
	if (!self.parent) return YES;
	return [self.parent childTableViewDataSourceShouldUpdateCells:self];	
}

@end
