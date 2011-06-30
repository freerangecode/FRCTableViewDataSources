/*
 DCTTableViewSectionController.m
 DCTUIKit
 
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

#import "DCTTableViewSectionController.h"

@interface DCTTableViewSectionController ()
- (id<UITableViewDataSource>)dctInternal_dataSourceForIndex:(NSInteger)index;
- (NSIndexPath *)dctInternal_convertedIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)dctInternal_convertedSection:(NSInteger)section;
@end

@implementation DCTTableViewSectionController {
	__strong NSMutableArray *dctInternal_tableViewSectionDataSources;
}

@synthesize tableView;

#pragma mark - NSObject

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	dctInternal_tableViewSectionDataSources = [[NSMutableArray alloc] init];
	
	return self;	
}

#pragma mark - DCTTableViewSectionController methods

- (void)addTableViewSectionDataSource:(id<UITableViewDataSource>)tableViewSectionDataSource {
	[dctInternal_tableViewSectionDataSources addObject:tableViewSectionDataSource];
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[dctInternal_tableViewSectionDataSources indexOfObject:tableViewSectionDataSource]];
	
	[self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeTableViewSectionDataSource:(id<UITableViewDataSource>)tableViewSectionDataSource {
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[dctInternal_tableViewSectionDataSources indexOfObject:tableViewSectionDataSource]];
	
	[dctInternal_tableViewSectionDataSources removeObject:tableViewSectionDataSource];
	
	[self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray *)tableViewSectionDataSources {
	return [dctInternal_tableViewSectionDataSources copy];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.tableViewSectionDataSources count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:section];
	
	return [ds tableView:table numberOfRowsInSection:[self dctInternal_convertedSection:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:indexPath.section];
	
	return [ds tableView:tv cellForRowAtIndexPath:[self dctInternal_convertedIndexPath:indexPath]];
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:section];
	
	if ([ds respondsToSelector:_cmd])
		return [ds tableView:tv titleForFooterInSection:[self dctInternal_convertedSection:section]];
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:section];
	
	section = [self dctInternal_convertedSection:section];
	
	if ([ds respondsToSelector:_cmd])
		return [ds tableView:tv titleForHeaderInSection:[self dctInternal_convertedSection:section]];
	
	return nil;
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:indexPath.section];
	
	if ([ds respondsToSelector:_cmd])
		[ds tableView:tv canEditRowAtIndexPath:[self dctInternal_convertedIndexPath:indexPath]];
	
	return NO;
	
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id<UITableViewDataSource> ds = [self dctInternal_dataSourceForIndex:indexPath.section];
	
	if ([ds respondsToSelector:_cmd])
		[ds tableView:tv commitEditingStyle:editingStyle forRowAtIndexPath:[self dctInternal_convertedIndexPath:indexPath]];
}

#pragma mark - Private methods

- (id<UITableViewDataSource>)dctInternal_dataSourceForIndex:(NSInteger)index {
	return [self.tableViewSectionDataSources objectAtIndex:index];
}

- (NSIndexPath *)dctInternal_convertedIndexPath:(NSIndexPath *)indexPath {
	return [NSIndexPath indexPathForRow:indexPath.row inSection:[self dctInternal_convertedSection:indexPath.section]];
}

- (NSInteger)dctInternal_convertedSection:(NSInteger)section {
	return 0;
}

@end
