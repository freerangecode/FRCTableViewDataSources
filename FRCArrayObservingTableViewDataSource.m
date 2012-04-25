/*
 FRCArrayObservingTableViewDataSource.m
 FRCTableViewDataSources
 
 Created by Daniel Tull on 24.04.2012.
 
 
 
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

#import "FRCArrayObservingTableViewDataSource.h"
#import "UITableView+FRCTableViewDataSources.h"

void* arrayObservingContext = &arrayObservingContext;

@implementation FRCArrayObservingTableViewDataSource {
	BOOL _shouldSetup;
	__strong NSArray *_array;
}
@synthesize object = _object;
@synthesize keyPath = _keyPath;

- (void)dealloc {
	[_object removeObserver:self 
				 forKeyPath:_keyPath
					context:arrayObservingContext];
}

- (id)initWithObject:(id)object arrayKeyPath:(NSString *)keyPath {
	if (!(self = [self init])) return nil;
	
	_object = object;
	_keyPath = keyPath;
	_array = [_object valueForKeyPath:_keyPath];
	
	[_object addObserver:self 
			  forKeyPath:keyPath
				 options:NSKeyValueObservingOptionNew
				 context:arrayObservingContext];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (context != arrayObservingContext)
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	_array = [_object valueForKeyPath:_keyPath];
	
	if (!_shouldSetup) return;
	
	NSKeyValueChange changeType = [[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue];
	NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
	
	NSMutableArray *indexPaths = [NSMutableArray new];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger i, BOOL *stop) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		indexPath = [self.tableView frc_convertIndexPath:indexPath fromChildTableViewDataSource:self];
		[indexPaths addObject:indexPath];
	}];
	
	[self.tableView beginUpdates];
	
	if (changeType == NSKeyValueChangeInsertion)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	else if (changeType == NSKeyValueChangeRemoval)
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	else if (changeType == NSKeyValueChangeReplacement)
		[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView endUpdates];
}

#pragma mark - FRCTableViewDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [_array objectAtIndex:indexPath.row];
}

- (void)reloadData {
	
	NSUInteger count = [_array count];
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:count];
	
	for (NSUInteger i = 0; i < count; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		indexPath = [self.tableView frc_convertIndexPath:indexPath fromChildTableViewDataSource:self];
		[indexPaths addObject:indexPath];
	}
	
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	_shouldSetup = YES;
	return [_array count];
}

@end
