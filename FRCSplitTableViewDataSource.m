/*
 FRCSplitTableViewDataSource.m
 FRCTableViewDataSources
 
 Created by Daniel Tull on 16.09.2010.
 
 
 
 Copyright (c) 2010 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FRCSplitTableViewDataSource.h"
#import "UITableView+FRCTableViewDataSources.h"

@interface FRCSplitTableViewDataSource ()
- (NSMutableArray *)frcInternal_tableViewDataSources;
- (void)frcInternal_setupDataSource:(FRCTableViewDataSource *)dataSource;
- (NSArray *)frcInternal_indexPathsForDataSource:(FRCTableViewDataSource *)dataSource;
@end

@implementation FRCSplitTableViewDataSource {
	__strong NSMutableArray *frcInternal_tableViewDataSources;
	BOOL tableViewHasSetup;
}

@synthesize type;

#pragma mark - FRCParentTableViewDataSource

- (NSArray *)childTableViewDataSources {
	return [[self frcInternal_tableViewDataSources] copy];
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	
	NSAssert([frcInternal_tableViewDataSources containsObject:dataSource], @"dataSource should be a child table view data source");
	
	NSArray *dataSources = [self frcInternal_tableViewDataSources];
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		__block NSInteger row = indexPath.row;
		
		[dataSources enumerateObjectsUsingBlock:^(FRCTableViewDataSource *ds, NSUInteger idx, BOOL *stop) {
						
			if ([ds isEqual:dataSource])
				*stop = YES;
			else
				row += [ds tableView:self.tableView numberOfRowsInSection:0];
			
		}];
		
		indexPath = [NSIndexPath indexPathForRow:row inSection:0];
		
	} else {
		
		indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:[dataSources indexOfObject:dataSource]];
	}
	
	return indexPath;
}

- (NSInteger)convertSection:(NSInteger)section fromChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	
	NSAssert([frcInternal_tableViewDataSources containsObject:dataSource], @"dataSource should be a child table view data source");
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) 
		section = 0;
	else 
		section = [[self frcInternal_tableViewDataSources] indexOfObject:dataSource];
	
	return section;
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	
	NSAssert([frcInternal_tableViewDataSources containsObject:dataSource], @"dataSource should be a child table view data source");
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		__block NSInteger totalRows = 0;
		NSInteger row = indexPath.row;
		
		[[self frcInternal_tableViewDataSources] enumerateObjectsUsingBlock:^(FRCTableViewDataSource *ds, NSUInteger idx, BOOL *stop) {
			
			NSInteger numberOfRows = [ds tableView:self.tableView numberOfRowsInSection:0];
						
			if ((totalRows + numberOfRows) > row)
				*stop = YES;
			else
				totalRows += numberOfRows;
		}];
		
		row = indexPath.row - totalRows;
		
		return [NSIndexPath indexPathForRow:row inSection:0];
	}
	
	return [NSIndexPath indexPathForRow:indexPath.row inSection:0];
}

- (NSInteger)convertSection:(NSInteger)section toChildTableViewDataSource:(FRCTableViewDataSource *)dataSource {
	NSAssert([frcInternal_tableViewDataSources containsObject:dataSource], @"dataSource should be a child table view data source");
	return 0;
}

- (FRCTableViewDataSource *)childTableViewDataSourceForSection:(NSInteger)section {
	
	NSArray *dataSources = [self frcInternal_tableViewDataSources];
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		if ([dataSources count] == 0) return nil;
		
		return [dataSources objectAtIndex:0];
	}
	
	return [dataSources objectAtIndex:section];
}

- (FRCTableViewDataSource *)childTableViewDataSourceForIndexPath:(NSIndexPath *)indexPath {
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		__block NSInteger totalRows = 0;
		__block FRCTableViewDataSource * dataSource = nil;
		NSInteger row = indexPath.row;
		
		[[self frcInternal_tableViewDataSources] enumerateObjectsUsingBlock:^(FRCTableViewDataSource *ds, NSUInteger idx, BOOL *stop) {
			
			NSInteger numberOfRows = [ds tableView:self.tableView numberOfRowsInSection:0];
			
			totalRows += numberOfRows;
			
			if (totalRows > row) {
				dataSource = ds;
				*stop = YES;
			}
		}];
		
		return dataSource;
	}
	
	return [[self frcInternal_tableViewDataSources] objectAtIndex:indexPath.section];
}

- (BOOL)childTableViewDataSourceShouldUpdateCells:(FRCTableViewDataSource *)dataSource {
	
	if (!self.parent) return YES;
		
	return [self.parent childTableViewDataSourceShouldUpdateCells:self];	
}


#pragma mark - FRCSplitTableViewDataSource methods

- (void)addChildTableViewDataSource:(FRCTableViewDataSource *)tableViewDataSource {
	
	NSMutableArray *childDataSources = [self frcInternal_tableViewDataSources];
	
	[childDataSources addObject:tableViewDataSource];
	
	[self frcInternal_setupDataSource:tableViewDataSource];
	
	if (!tableViewHasSetup) return;
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		NSArray *indexPaths = [self frcInternal_indexPathsForDataSource:tableViewDataSource];
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:FRCTableViewDataSourceTableViewRowAnimationAutomatic];
		
	} else {
		
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[childDataSources indexOfObject:tableViewDataSource]];
		[self.tableView insertSections:indexSet withRowAnimation:FRCTableViewDataSourceTableViewRowAnimationAutomatic];
		
	}
}

- (void)removeChildTableViewDataSource:(FRCTableViewDataSource *)tableViewDataSource {
	
	NSAssert([frcInternal_tableViewDataSources containsObject:tableViewDataSource], @"dataSource should be a child table view data source");
	
	NSMutableArray *childDataSources = [self frcInternal_tableViewDataSources];
	
	
	if (self.type == FRCSplitTableViewDataSourceTypeRow) {
		
		NSArray *indexPaths = [self frcInternal_indexPathsForDataSource:tableViewDataSource];
		
		[childDataSources removeObject:tableViewDataSource];
		
		if (!tableViewHasSetup) return;
		
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:FRCTableViewDataSourceTableViewRowAnimationAutomatic];
	
	} else {
	
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[childDataSources indexOfObject:tableViewDataSource]];
	
		[childDataSources removeObject:tableViewDataSource];
	
		if (!tableViewHasSetup) return;
	
		[self.tableView deleteSections:indexSet withRowAnimation:FRCTableViewDataSourceTableViewRowAnimationAutomatic];
	
	}
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	tableViewHasSetup = YES;
	self.tableView = tv;
	return [[self frcInternal_tableViewDataSources] count];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	tableViewHasSetup = YES;
	if (self.type == FRCSplitTableViewDataSourceTypeSection)
		return [super tableView:tv numberOfRowsInSection:section];
	
	
	__block NSInteger numberOfRows = 0;
	
	[[self frcInternal_tableViewDataSources] enumerateObjectsUsingBlock:^(FRCTableViewDataSource * ds, NSUInteger idx, BOOL *stop) {
		numberOfRows += [ds tableView:self.tableView numberOfRowsInSection:0];
	}];
	
	return numberOfRows;
}

#pragma mark - Private methods

- (NSArray *)frcInternal_indexPathsForDataSource:(FRCTableViewDataSource *)dataSource {
	
	NSInteger numberOfRows = [dataSource tableView:self.tableView numberOfRowsInSection:0];
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	
	for (NSInteger i = 0; i < numberOfRows; i++) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
		ip = [self.tableView frc_convertIndexPath:ip fromChildTableViewDataSource:dataSource];
		[indexPaths addObject:ip];
	}
	
	return [indexPaths copy];
}

- (NSMutableArray *)frcInternal_tableViewDataSources {
	
	if (!frcInternal_tableViewDataSources) 
		frcInternal_tableViewDataSources = [[NSMutableArray alloc] init];
	
	return frcInternal_tableViewDataSources;	
}
		 
- (void)frcInternal_setupDataSource:(FRCTableViewDataSource *)dataSource {
	dataSource.tableView = self.tableView;
	dataSource.parent = self;
}

@end
