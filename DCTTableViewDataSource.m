/*
 DCTTableViewDataSource.h
 DCTUIKit
 
 Created by Daniel Tull on 20.5.2011.
 
 
 
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

#import "DCTTableViewDataSource.h"
#import "DCTTableViewCell.h"

@implementation DCTTableViewDataSource {
	__weak id<DCTTableViewDataSourceParent> parent;
}

@synthesize tableView;
@synthesize cellClass;
@synthesize parent;
@synthesize cellGenerator;

#pragma mark - NSObject

- (id)init {
    
    if (!(self = [super init])) return nil;
	
	self.cellClass = [UITableViewCell class];
	
    return self;
}

#pragma mark - DCTTableViewDataSource

- (void)setCellClass:(Class)aCellClass {
	
	cellClass = aCellClass;
	
	[self.tableView dct_registerDCTTableViewCellSubclass:self.cellClass];
}

- (void)setTableView:(UITableView *)tv {
	
	if (self.tableView == tv) return;
	
	tableView = tv;
	
	[self.tableView dct_registerDCTTableViewCellSubclass:self.cellClass];
}

- (void)reloadData {}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellIdentifier = nil;
	
	if ([self.cellClass isSubclassOfClass:[DCTTableViewCell class]])
		cellIdentifier = [self.cellClass reuseIdentifier];
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil && self.cellGenerator != nil)
		cell = self.cellGenerator(tv, indexPath);
	
	if (cell == nil) {
		cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Cell with indexPath: %i.%i", indexPath.section, indexPath.row];
    }
    
	if ([cell conformsToProtocol:@protocol(DCTTableViewCell)])
		[((id <DCTTableViewCell>)cell) configureWithObject:[self objectAtIndexPath:indexPath]];
	
	return cell;
}

@end
