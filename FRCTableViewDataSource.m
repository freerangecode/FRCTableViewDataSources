/*
 FRCTableViewDataSource.h
 FRCTableViewDataSources
 
 Created by Daniel Tull on 20.05.2011.
 
 
 
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

#import "FRCTableViewDataSource.h"
#import "FRCTableViewCell.h"
#import "UITableView+FRCTableViewDataSources.h"

@implementation FRCTableViewDataSource

@synthesize tableView;
@synthesize cellClass;
@synthesize parent;

#pragma mark - NSObject

- (void)dealloc {
	dct_nil(self.parent);
}

- (id)init {
    
    if (!(self = [super init])) return nil;
	
	self.cellClass = [FRCTableViewCell class];
	
    return self;
}

#pragma mark - FRCTableViewDataSource

- (void)setCellClass:(Class)aCellClass {
	
	cellClass = aCellClass;
	
	[self.tableView frc_registerFRCTableViewCellSubclass:self.cellClass];
}

- (void)setTableView:(UITableView *)tv {
	
	if (self.tableView == tv) return;
	
	tableView = tv;
	
	[self.tableView frc_registerFRCTableViewCellSubclass:self.cellClass];
}

- (void)reloadData {}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	return [self cellClass];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = nil;
	
	Class theCellClass = [self cellClassAtIndexPath:indexPath];
	
	if ([theCellClass isSubclassOfClass:[FRCTableViewCell class]])
		cellIdentifier = [theCellClass reuseIdentifier];
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell && [theCellClass isSubclassOfClass:[FRCTableViewCell class]])
		cell = [theCellClass cell];
	
	if (!cell)
		cell = [[theCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
	id object = [self objectAtIndexPath:indexPath];
	
	[self configureCell:cell atIndexPath:indexPath withObject:object];
	
	if ([cell conformsToProtocol:@protocol(DCTTableViewCellObjectConfiguration)])
		[(id<DCTTableViewCellObjectConfiguration>)cell configureWithObject:object];
	
	return cell;
}

@end
