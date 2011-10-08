/*
 DCTParentTableViewDataSource.m
 DCTTableViewDataSources
 
 Created by Daniel Tull on 20.08.2011.
 
 
 
 Copyright (c) 2011 Daniel Tull. All rights reserved.
 
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

#import "DCTParentTableViewDataSource.h"

@interface DCTParentTableViewDataSource ()
- (id<DCTParentTableViewDataSource>)dctInternal_ptvdsSelf;
@end

@implementation DCTParentTableViewDataSource

@synthesize tableView;
@synthesize parent;

#pragma mark - NSObject

- (void)dealloc {
	dct_nil(self.parent);
}

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	for (id<DCTTableViewDataSource> ds in self.dctInternal_ptvdsSelf.childTableViewDataSources)
		[ds reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	return [ds objectAtIndexPath:indexPath];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	return [ds cellClassAtIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	section = [self.dctInternal_ptvdsSelf convertSection:section toChildTableViewDataSource:ds];
	return [ds tableView:tv numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	return [ds tableView:tv cellForRowAtIndexPath:indexPath];
}

#pragma mark Optional

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	section = [self.dctInternal_ptvdsSelf convertSection:section toChildTableViewDataSource:ds];
	return [ds tableView:tv titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForSection:section];
	
	if (![ds respondsToSelector:_cmd]) return nil;
	
	section = [self.dctInternal_ptvdsSelf convertSection:section toChildTableViewDataSource:ds];
	return [ds tableView:tv titleForFooterInSection:section];
}

#pragma mark Editing

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return NO;
	
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	return [ds tableView:tv canEditRowAtIndexPath:indexPath];
}

#pragma mark Moving/reordering

- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return NO;
	
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	return [ds tableView:tv canMoveRowAtIndexPath:indexPath];
}

#pragma mark  Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:indexPath];
	
	if (![ds respondsToSelector:_cmd]) return;
	
	indexPath = [self.dctInternal_ptvdsSelf convertIndexPath:indexPath toChildTableViewDataSource:ds];
	[ds tableView:tv commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	id<DCTTableViewDataSource> ds = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:sourceIndexPath];
	NSIndexPath *dsSourceIndexPath = [self.dctInternal_ptvdsSelf convertIndexPath:sourceIndexPath toChildTableViewDataSource:ds];
	NSIndexPath *dsDestinationIndexPath = [self.dctInternal_ptvdsSelf convertIndexPath:sourceIndexPath toChildTableViewDataSource:ds];
	
	id<DCTTableViewDataSource> ds2 = [self.dctInternal_ptvdsSelf childDataSourceForIndexPath:destinationIndexPath];
	NSIndexPath *ds2SourceIndexPath = [self.dctInternal_ptvdsSelf convertIndexPath:sourceIndexPath toChildTableViewDataSource:ds2];
	NSIndexPath *ds2DestinationIndexPath = [self.dctInternal_ptvdsSelf convertIndexPath:destinationIndexPath toChildTableViewDataSource:ds2];
	
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
