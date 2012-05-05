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
#import "UITableView+FRCNibRegistration.h"

@interface FRCTableViewDataSource ()
- (void)frcInternal_setupCellClass;
@end

@implementation FRCTableViewDataSource {
	__strong NSMutableDictionary *_cellClassDictionary;
}

@synthesize tableView;
@synthesize cellClass = _cellClass;
@synthesize parent;
@synthesize sectionHeaderTitle;
@synthesize sectionFooterTitle;
@synthesize cellConfigurer;

#pragma mark - NSObject

- (void)dealloc {
	frc_nil(self.parent);
}

- (id)init {
    
    if (!(self = [super init])) return nil;
	
	self.cellClass = [FRCTableViewCell class];
	_cellClassDictionary = [NSMutableDictionary new];
	
    return self;
}

#pragma mark - FRCTableViewDataSource

- (void)setCellClass:(Class)aCellClass {
	_cellClass = aCellClass;
	[self frcInternal_setupCellClass];
}

- (void)setCellClass:(Class)cellClass forObjectClass:(Class)objectClass {
	[_cellClassDictionary setObject:cellClass forKey:objectClass];
}

- (Class)cellClassForObjectClass:(Class)objectClass {
	return [_cellClassDictionary objectForKey:objectClass];
}

- (void)setTableView:(UITableView *)tv {
	
	if (tv == tableView) return;
	
	tableView = tv;
	[self frcInternal_setupCellClass];
}

- (void)reloadData {}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	
	Class objectClass = [[self objectAtIndexPath:indexPath] class];
	Class cellClass = [self cellClassForObjectClass:objectClass];
	if (cellClass != NULL) return cellClass;
	
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
	
    UITableViewCell *cell = [tv frc_dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell && [theCellClass isSubclassOfClass:[FRCTableViewCell class]])
		cell = [theCellClass cell];
	
	if (!cell)
		cell = [[theCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
	id object = [self objectAtIndexPath:indexPath];
	
	[self configureCell:cell atIndexPath:indexPath withObject:object];
	
	if ([cell conformsToProtocol:@protocol(FRCTableViewCellObjectConfiguration)])
		[(id<FRCTableViewCellObjectConfiguration>)cell configureWithObject:object];
	
	if (self.cellConfigurer != NULL) self.cellConfigurer(cell, indexPath, object);
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return self.sectionFooterTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sectionHeaderTitle;
}

#pragma mark - Internal

- (void)frcInternal_setupCellClass {
	
	if (!self.tableView) return;
	
	if (![self.cellClass isSubclassOfClass:[FRCTableViewCell class]]) return;
	
	NSString *nibName = [self.cellClass nibName];
	
	if ([nibName length] < 1) return;
	
	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
	NSString *reuseIdentifier = [self.cellClass reuseIdentifier];
	
	[self.tableView frc_registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

@end
