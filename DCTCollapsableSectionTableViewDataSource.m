/*
 DCTCollapsableSectionTableViewDataSource.m
 DCTTableViewDataSources
 
 Created by Daniel Tull on 30.06.2011.
 
 
 
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

#import "DCTCollapsableSectionTableViewDataSource.h"
#import "DCTParentTableViewDataSource.h"
#import "DCTTableViewCell.h"
#import "UITableView+DCTTableViewDataSources.h"
#import <QuartzCore/QuartzCore.h>

@interface DCTCollapsableSectionTableViewDataSource ()
- (void)dctInternal_setupTableViewDataSource;
- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender;
- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender;
- (void)dctInternal_headerCellWillBeReused:(NSNotification *)notification;

- (NSArray *)dctInternal_indexPathsForCollapsableCells;
- (NSArray *)dctInternal_indexPathsForCollapsableCellsIndexPathEnumator:(void (^)(NSIndexPath *))block;
- (NSIndexPath *)dctInternal_headerIndexPath;
- (void)dctInternal_setOpened;
- (void)dctInternal_setClosed;
@end

@implementation DCTCollapsableSectionTableViewDataSource {
	__strong NSString *tableViewCellIdentifier;
	__strong UITableViewCell *headerCell;
}

@synthesize childTableViewDataSource;
@synthesize greyWhenEmpty;
@synthesize title;
@synthesize type;
@synthesize opened;
@synthesize titleCellClass;
@synthesize titleSelectionHandler;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DCTTableViewCellWillBeReusedNotification object:headerCell];
}

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	titleCellClass = [UITableViewCell class];
	
	return self;
}

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	[self.childTableViewDataSource reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) return nil;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.childTableViewDataSource objectAtIndexPath:ip];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) return self.titleCellClass;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.childTableViewDataSource cellClassAtIndexPath:ip];
}

#pragma mark - DCTTableViewDataSourceParent

- (NSArray *)childTableViewDataSources {
	return [NSArray arrayWithObject:self.childTableViewDataSource];
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	indexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
	
	if (self.parent == nil) return indexPath;	
	
	return [self.parent convertIndexPath:indexPath fromChildTableViewDataSource:self];
}

- (NSInteger)convertSection:(NSInteger)section fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	return [self.parent convertSection:section fromChildTableViewDataSource:self];
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
}

- (NSInteger)convertSection:(NSInteger)section toChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	
	NSAssert(dataSource == self.childTableViewDataSource, @"dataSource should be the childTableViewDataSource");
	
	return 0;
}

- (id<DCTTableViewDataSource>)childDataSourceForSection:(NSInteger)section {
	return self.childTableViewDataSource;
}

- (id<DCTTableViewDataSource>)childDataSourceForIndexPath:(NSIndexPath *)indexPath {
	return self.childTableViewDataSource;
}

- (BOOL)childTableViewDataSourceShouldUpdateCells:(id<DCTTableViewDataSource>)dataSource {
	
	if (!self.opened) return NO;
	
	if (self.parent == nil) return YES;
	
	return [self.parent childTableViewDataSourceShouldUpdateCells:self];	
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	
	NSInteger numberOfRows = 0;
	
	if (self.opened) numberOfRows = [super tableView:tv numberOfRowsInSection:0];
	
	return numberOfRows + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > 0)
		return [super tableView:tv cellForRowAtIndexPath:indexPath];
	
	if (tableViewCellIdentifier == nil) 
		tableViewCellIdentifier = NSStringFromClass(self.titleCellClass);
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
	
	if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
	
	cell.textLabel.text = self.title;
	cell.accessoryView = nil;

	NSInteger numberOfRows = [self.childTableViewDataSource tableView:tv numberOfRowsInSection:0];
	
	if (numberOfRows == 0 && self.greyWhenEmpty)
		cell.textLabel.textColor = [UIColor lightGrayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];
	
	if (self.type == DCTCollapsableSectionTableViewDataSourceTypeCell) {
		
		UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dctInternal_titleTapped:)]; 
		[cell addGestureRecognizer:gr];
		
		UIImage *image = [UIImage imageNamed:@"DCTCollapsableSectionTableViewDataSourceDisclosureIndicator.png"];
		UIImageView *iv = [[UIImageView alloc] initWithImage:image];
		iv.highlightedImage = [UIImage imageNamed:@"DCTCollapsableSectionTableViewDataSourceDisclosureIndicatorHighlighted.png"];
		cell.accessoryView = iv;
		cell.accessoryView.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
	} else if (self.type == DCTCollapsableSectionTableViewDataSourceTypeDisclosure) {
		
		if (numberOfRows > 0) {
			
			UIImage *image = [UIImage imageNamed:@"DCTCollapsableSectionTableViewDataSourceDisclosureButton.png"];
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);	
			[button setBackgroundImage:image forState:UIControlStateNormal];
			[button addTarget:self action:@selector(dctInternal_disclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			button.backgroundColor = [UIColor clearColor];
			button.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
			cell.accessoryView = button;
		}
		
		if (!self.titleSelectionHandler) cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	id object = [self objectAtIndexPath:indexPath];
	
	if ([cell conformsToProtocol:@protocol(DCTTableViewCellObjectConfiguration)])
		[(id<DCTTableViewCellObjectConfiguration>)cell configureWithObject:object];
	
	[self configureCell:headerCell atIndexPath:indexPath withObject:object];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:DCTTableViewCellWillBeReusedNotification 
												  object:headerCell];
	
	headerCell = cell;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(dctInternal_headerCellWillBeReused:) 
												 name:DCTTableViewCellWillBeReusedNotification 
											   object:headerCell];
	
	return headerCell;
}

- (void)dctInternal_headerCellWillBeReused:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DCTTableViewCellWillBeReusedNotification object:headerCell];
	headerCell = nil;
}

- (NSArray *)dctInternal_indexPathsForCollapsableCells {
	return [self dctInternal_indexPathsForCollapsableCellsIndexPathEnumator:nil];
}

- (NSArray *)dctInternal_indexPathsForCollapsableCellsIndexPathEnumator:(void (^)(NSIndexPath *))block {
	
	NSInteger numberOfRows = [self.childTableViewDataSource tableView:self.tableView numberOfRowsInSection:0];
	
	if (numberOfRows < 0) return nil;
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	
	for (NSInteger i = 1; i <= numberOfRows; i++) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
		
		if (block) block(ip);
		
		if (self.parent) ip = [self.parent convertIndexPath:ip fromChildTableViewDataSource:self];
		[indexPaths addObject:ip];
	}
	
	return [indexPaths copy];
}

- (NSIndexPath *)dctInternal_headerIndexPath {
	NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.parent) headerIndexPath = [self.parent convertIndexPath:headerIndexPath fromChildTableViewDataSource:self];
	return headerIndexPath;
}

- (void)dctInternal_setOpened {
	
	__block CGFloat totalCellHeight = headerCell.bounds.size.height;
	CGFloat tableViewHeight = self.tableView.bounds.size.height;
	
	// If it's grouped we need room for the space between sections.
	if (self.tableView.style == UITableViewStyleGrouped)
		tableViewHeight -= 20.0f;
	
	NSArray *indexPaths = [self dctInternal_indexPathsForCollapsableCellsIndexPathEnumator:^(NSIndexPath *ip) {
		
		if (totalCellHeight < tableViewHeight) { // Add this check so we can reduce the amount of calls to heightForObject:width:
			Class cellClass = [self cellClassAtIndexPath:ip];
			totalCellHeight += [cellClass heightForObject:[self objectAtIndexPath:ip] width:self.tableView.bounds.size.width];
		}
		
	}];
	
	if ([indexPaths count] == 0) return;
	
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];
	
	NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.parent) headerIndexPath = [self.parent convertIndexPath:headerIndexPath fromChildTableViewDataSource:self];
	
	if (totalCellHeight < tableViewHeight) {
		[self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionNone animated:YES];
		[self.tableView scrollToRowAtIndexPath:headerIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
	} else {
		[self.tableView scrollToRowAtIndexPath:headerIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

- (void)dctInternal_setClosed {
	NSArray *indexPaths = [self dctInternal_indexPathsForCollapsableCells];
	
	if ([indexPaths count] == 0) return;
	
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];
	
	[self.tableView scrollToRowAtIndexPath:[self dctInternal_headerIndexPath]
						  atScrollPosition:UITableViewScrollPositionNone
								  animated:YES];
}

- (void)setOpened:(BOOL)aBool {
	
	if (opened == aBool) return;
	
	opened = aBool;
	
	if (aBool)
		[self dctInternal_setOpened];
	else 
		[self dctInternal_setClosed];
		
	UIView *accessoryView = headerCell.accessoryView;
	
	if (!accessoryView) return;
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	accessoryView.layer.transform = CATransform3DMakeRotation(aBool ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
}

- (void)setTableView:(UITableView *)tv {
	
	if (tv == self.tableView) return;
	
	[super setTableView:tv];
	
	[self dctInternal_setupTableViewDataSource];
}

- (void)setChildTableViewDataSource:(id<DCTTableViewDataSource>)ds {
	
	if (childTableViewDataSource == ds) return;
	
	childTableViewDataSource = ds;
	
	[self dctInternal_setupTableViewDataSource];	
}

- (void)setTitleCellClass:(Class)cellClass {
	
	if (titleCellClass == cellClass) return;
	
	titleCellClass = cellClass;
	
	[self dctInternal_setupTableViewDataSource];
}

- (void)dctInternal_setupTableViewDataSource {	
	self.childTableViewDataSource.tableView = self.tableView;
	self.childTableViewDataSource.parent = self;
	[self.tableView dct_registerDCTTableViewCellSubclass:self.titleCellClass];
}

- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender {
	self.opened = !self.opened;
}

- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender {
	self.opened = !self.opened;
}

@end
