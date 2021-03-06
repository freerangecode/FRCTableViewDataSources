/*
 FRCCollapsableSectionTableViewDataSource.m
 FRCTableViewDataSources
 
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

#import "FRCCollapsableSectionTableViewDataSource.h"
#import "FRCParentTableViewDataSource.h"
#import "FRCTableViewCell.h"
#import "UITableView+FRCTableViewDataSources.h"
#import <QuartzCore/QuartzCore.h>
#import "FRCObjectTableViewDataSource.h"
#import "FRCSplitTableViewDataSource.h"



@implementation FRCCollapsableSectionTableViewDataSourceHeader {
	__strong NSString *title;
	BOOL open;
	BOOL empty;
}
@synthesize title;
@synthesize open;
@synthesize empty;
- (id)initWithTitle:(NSString *)aTitle open:(BOOL)isOpen empty:(BOOL)isEmpty {
	
	if (!(self = [super init])) return nil;
	
	title = [aTitle copy];
	open = isOpen;
	empty = isEmpty;
	
	return self;
}
@end








@interface FRCCollapsableSectionTableViewDataSourceHeaderTableViewCell : FRCTableViewCell
@end
@implementation FRCCollapsableSectionTableViewDataSourceHeaderTableViewCell
- (void)configureWithObject:(FRCCollapsableSectionTableViewDataSourceHeader *)object {
	
	self.textLabel.text = object.title;
	
	if (object.empty) {
		self.textLabel.textColor = [UIColor lightGrayColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		self.textLabel.textColor = [UIColor blackColor];
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
}
@end















@interface FRCCollapsableSectionTableViewDataSource ()


- (NSArray *)frcInternal_tableViewIndexPathsForCollapsableCellsIndexPathEnumator:(void (^)(NSIndexPath *))block;

- (IBAction)frcInternal_titleTapped:(UITapGestureRecognizer *)sender;
- (void)frcInternal_setOpened;
- (void)frcInternal_setClosed;

- (void)frcInternal_headerCheck;
- (BOOL)frcInternal_childTableViewDataSourceCurrentlyHasCells;

- (void)frcInternal_setSplitChild:(FRCTableViewDataSource *)dataSource;

@property (nonatomic, readonly) NSIndexPath *frcInternal_headerTableViewIndexPath;
@property (nonatomic, readonly) UITableViewCell *frcInternal_headerCell;

@end

@implementation FRCCollapsableSectionTableViewDataSource {
	BOOL childTableViewDataSourceHasCells;
	BOOL canReloadHeaderCell;
	
	BOOL tableViewHasLoaded;
	
	__strong FRCSplitTableViewDataSource *splitDataSource;
	__strong FRCObjectTableViewDataSource *headerDataSource;
}

@synthesize childTableViewDataSource;
@synthesize title;
@synthesize open;
@synthesize titleCellClass;

#pragma mark - NSObject

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	splitDataSource = [[FRCSplitTableViewDataSource alloc] init];
	splitDataSource.type = FRCSplitTableViewDataSourceTypeRow;
	splitDataSource.parent = self;
	
	headerDataSource = [[FRCObjectTableViewDataSource alloc] init];
	headerDataSource.cellClass = [FRCCollapsableSectionTableViewDataSourceHeaderTableViewCell class];
	
	[splitDataSource addChildTableViewDataSource:headerDataSource];
	
	return self;
}

#pragma mark - FRCCollapsableSectionTableViewDataSource

- (FRCTableViewDataSource *)childTableViewDataSource {
	
	if (!childTableViewDataSource)
		[self loadChildTableViewDataSource];
	
	return childTableViewDataSource;	
}

- (void)setChildTableViewDataSource:(FRCTableViewDataSource *)ds {
	
	if (childTableViewDataSource == ds) return;
	
	childTableViewDataSource = ds;
	
	if (self.open && ds)
		[self frcInternal_setSplitChild:ds];
	else {
		ds.parent = self; // This makes it ask us if it should update, to which we'll respond no when it's not showing.
		ds.tableView = nil;
	}
	[self frcInternal_headerCheck];
}

- (void)loadChildTableViewDataSource {}

#pragma mark - FRCTableViewDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) 
		return [[FRCCollapsableSectionTableViewDataSourceHeader alloc] initWithTitle:self.title open:self.open empty:![self frcInternal_childTableViewDataSourceCurrentlyHasCells]];
	
	return [super objectAtIndexPath:indexPath];
}

#pragma mark - FRCParentTableViewDataSource

- (NSArray *)childTableViewDataSources {
	return [NSArray arrayWithObject:splitDataSource];
}

- (BOOL)childTableViewDataSourceShouldUpdateCells:(FRCTableViewDataSource *)dataSource {
	
	canReloadHeaderCell = YES;	
	[self frcInternal_headerCheck];
	
	if (!self.open) return NO;
	
	if (self.parent == nil) return YES;
	
	return [self.parent childTableViewDataSourceShouldUpdateCells:self];	
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.tableView = tv;
	tableViewHasLoaded = YES;
	
	if (indexPath.row == 0)
		headerDataSource.object = [self objectAtIndexPath:indexPath];
	
	UITableViewCell *cell = [super tableView:tv cellForRowAtIndexPath:indexPath];
	
	if (indexPath.row == 0) {
		
		UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frcInternal_titleTapped:)]; 
		[cell addGestureRecognizer:gr];
		gr.delaysTouchesBegan = NO;
		gr.delaysTouchesEnded = NO;
		
		if ([self frcInternal_childTableViewDataSourceCurrentlyHasCells]) {
			UIImage *image = [UIImage imageNamed:@"FRCCollapsableSectionTableViewDataSourceDisclosureIndicator.png"];
			UIImageView *iv = [[UIImageView alloc] initWithImage:image];
			iv.highlightedImage = [UIImage imageNamed:@"FRCCollapsableSectionTableViewDataSourceDisclosureIndicatorHighlighted.png"];
			cell.accessoryView = iv;			
			cell.accessoryView.layer.transform = CATransform3DMakeRotation(self.open ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
		} else {
			cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}	
	}
	
	return cell;
}

#pragma mark - Internal

- (IBAction)frcInternal_titleTapped:(UITapGestureRecognizer *)sender {
	self.open = !self.open;
}

- (NSArray *)frcInternal_tableViewIndexPathsForCollapsableCellsIndexPathEnumator:(void (^)(NSIndexPath *))block {
	
	NSInteger numberOfRows = [self.childTableViewDataSource tableView:self.tableView numberOfRowsInSection:0];
	
	if (numberOfRows == 0) {
		childTableViewDataSourceHasCells = NO;
		return nil;
	}
	
	childTableViewDataSourceHasCells = YES;
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
	
	for (NSInteger i = 0; i < numberOfRows; i++) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
		
		if (block) block(ip);
		
		ip = [self.tableView frc_convertIndexPath:ip fromChildTableViewDataSource:self.childTableViewDataSource];
		[indexPaths addObject:ip];
	}
	
	return [indexPaths copy];
}

- (void)frcInternal_setSplitChild:(FRCTableViewDataSource *)dataSource {
	NSArray *children = splitDataSource.childTableViewDataSources;
	if ([children count] > 1) [splitDataSource removeChildTableViewDataSource:[children lastObject]];
	
	[splitDataSource addChildTableViewDataSource:self.childTableViewDataSource];
}

- (void)frcInternal_setOpened {
	
	[self frcInternal_setSplitChild:self.childTableViewDataSource];
	
	if (!tableViewHasLoaded) return;
	
	__block CGFloat totalCellHeight = self.frcInternal_headerCell.bounds.size.height;
	CGFloat tableViewHeight = self.tableView.bounds.size.height;
	
	// If it's grouped we need room for the space between sections.
	if (self.tableView.style == UITableViewStyleGrouped)
		tableViewHeight -= 20.0f;
	
	NSArray *indexPaths = [self frcInternal_tableViewIndexPathsForCollapsableCellsIndexPathEnumator:^(NSIndexPath *ip) {
		
		if (totalCellHeight < tableViewHeight) { // Add this check so we can reduce the amount of calls to heightForObject:width:
			Class cellClass = [self cellClassAtIndexPath:ip];
			totalCellHeight += [cellClass heightForObject:[self objectAtIndexPath:ip] width:self.tableView.bounds.size.width];
		}
		
	}];
	
	if ([indexPaths count] == 0) return;
	
	NSIndexPath *headerIndexPath = self.frcInternal_headerTableViewIndexPath;
	
	if (totalCellHeight < tableViewHeight) {
		[self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionNone animated:YES];
		[self.tableView scrollToRowAtIndexPath:headerIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
	} else {
		[self.tableView scrollToRowAtIndexPath:headerIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

- (void)frcInternal_setClosed {
	
	NSArray *children = splitDataSource.childTableViewDataSources;
	if ([children count] == 1) return;
	
	[splitDataSource removeChildTableViewDataSource:self.childTableViewDataSource];
	self.childTableViewDataSource.parent = self; // This makes it ask us if it should update, to which we'll respond no when it's not showing.
	self.childTableViewDataSource.tableView = nil;
	
	[self.tableView scrollToRowAtIndexPath:self.frcInternal_headerTableViewIndexPath
						  atScrollPosition:UITableViewScrollPositionNone
								  animated:YES];
}

- (void)setOpen:(BOOL)aBool {
	
	if (open == aBool) return;
	
	open = aBool;
	
	if (aBool)
		[self frcInternal_setOpened];
	else 
		[self frcInternal_setClosed];
	
	UIView *accessoryView = self.frcInternal_headerCell.accessoryView;
	
	if (!accessoryView) return;
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	accessoryView.layer.transform = CATransform3DMakeRotation(aBool ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
}

- (void)setTitleCellClass:(Class)cellClass {
	
	if (titleCellClass == cellClass) return;
	
	titleCellClass = cellClass;
	headerDataSource.cellClass = cellClass;
}

- (void)frcInternal_headerCheck {
	
	if (!canReloadHeaderCell) return;
	
	if (childTableViewDataSourceHasCells == [self frcInternal_childTableViewDataSourceCurrentlyHasCells]) return;
	
	childTableViewDataSourceHasCells = !childTableViewDataSourceHasCells;
	
	NSIndexPath *headerIndexPath = self.frcInternal_headerTableViewIndexPath;
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:headerIndexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)frcInternal_childTableViewDataSourceCurrentlyHasCells {
	return ([self.childTableViewDataSource tableView:self.tableView numberOfRowsInSection:0] > 0);
}



#pragma mark - Header Cell

- (NSIndexPath *)frcInternal_headerTableViewIndexPath {
	NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	return [self.tableView frc_convertIndexPath:headerIndexPath fromChildTableViewDataSource:self];
}

- (UITableViewCell *)frcInternal_headerCell {
	return [self.tableView cellForRowAtIndexPath:self.frcInternal_headerTableViewIndexPath];
}

@end
