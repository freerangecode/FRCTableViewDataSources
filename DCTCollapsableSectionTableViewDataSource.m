//
//  DCTCollapsableSectionTableViewDataSource.m
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTCollapsableSectionTableViewDataSource.h"
#import "DCTParentTableViewDataSource.h"
#import "DCTTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DCTCollapsableSectionTableViewDataSource ()
- (void)dctInternal_setupTableViewDataSource;
- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender;
- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender;
- (void)dctInternal_headerCellWillBeReused:(NSNotification *)notification;
@end

@implementation DCTCollapsableSectionTableViewDataSource {
	__strong NSString *tableViewCellIdentifier;
	__weak id<DCTParentTableViewDataSource> parent;
	__strong UITableViewCell *headerCell;
}

@synthesize tableViewDataSource;
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
	[self.tableViewDataSource reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) return nil;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.tableViewDataSource objectAtIndexPath:ip];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) return self.titleCellClass;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.tableViewDataSource cellClassAtIndexPath:ip];
}

#pragma mark - DCTCollapsableSectionTableViewDataSource

- (id<DCTTableViewDataSource>)tableViewDataSource {
	
	if (!tableViewDataSource) [self loadTableViewDataSource];
	
	return tableViewDataSource;
}

- (void)loadTableViewDataSource {}

#pragma mark - DCTTableViewDataSourceParent

- (NSArray *)childTableViewDataSources {
	return [NSArray arrayWithObject:self.tableViewDataSource];
}

- (NSIndexPath *)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewIndexPathForDataIndexPath:(NSIndexPath *)indexPath {
	indexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
	
	if (self.parent == nil) return indexPath;	
	
	return [self.parent childTableViewDataSource:self tableViewIndexPathForDataIndexPath:indexPath];
}

- (NSInteger)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewSectionForDataSection:(NSInteger)section {
	return [self.parent childTableViewDataSource:self tableViewSectionForDataSection:section];
}

- (NSIndexPath *)dataIndexPathForTableViewIndexPath:(NSIndexPath *)indexPath {
	return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
}

- (NSInteger)dataSectionForTableViewSection:(NSInteger)section {
	return 0;
}

- (id<DCTTableViewDataSource>)childDataSourceForSection:(NSInteger)section {
	return self.tableViewDataSource;
}

- (id<DCTTableViewDataSource>)childDataSourceForIndexPath:(NSIndexPath *)indexPath {
	return self.tableViewDataSource;
}

- (BOOL)tableViewDataSourceShouldUpdateCells:(id<DCTTableViewDataSource>)dataSource {
	
	if (!self.opened) return NO;
	
	if (self.parent == nil) return YES;
	
	return [self.parent tableViewDataSourceShouldUpdateCells:self];	
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

	NSInteger numberOfRows = [self.tableViewDataSource tableView:tv numberOfRowsInSection:0];
	
	if (numberOfRows == 0 && self.greyWhenEmpty)
		cell.textLabel.textColor = [UIColor lightGrayColor];
	else
		cell.textLabel.textColor = [UIColor blackColor];
	
	if (self.type == DCTCollapsableSectionTableViewDataSourceTypeCell) {
		
		UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dctInternal_titleTapped:)]; 
		[cell addGestureRecognizer:gr];
		
		UIImage *image = [UIImage imageNamed:@"DCTCollapsableSectionTableViewDataSourceDisclosureIndicator.png"];
		
		cell.accessoryView = [[UIImageView alloc] initWithImage:image];
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
	
	if ([cell conformsToProtocol:@protocol(DCTTableViewCell)]) {
		id<DCTTableViewCell> dctCell = (id<DCTTableViewCell>)cell;
		[dctCell configureWithObject:object];
	}
	
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

- (void)setOpened:(BOOL)aBool {
	
	if (opened == aBool) return;
	
	opened = aBool;
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < [self.tableViewDataSource tableView:self.tableView numberOfRowsInSection:0]; i++) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i+1 inSection:0];
		if (self.parent != nil) ip = [self.parent childTableViewDataSource:self tableViewIndexPathForDataIndexPath:ip];
		[indexPaths addObject:ip];
	}
	
	if ([indexPaths count] == 0) return;
	
	[self.tableView beginUpdates];
	
	if (aBool)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	else
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self.tableView endUpdates];
	
	NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.parent != nil) headerIndexPath = [self.parent childTableViewDataSource:self tableViewIndexPathForDataIndexPath:headerIndexPath];
	
	if (aBool) {
		[self.tableView scrollToRowAtIndexPath:headerIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
	
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

- (void)setTableViewDataSource:(id<DCTTableViewDataSource>)ds {
	
	if (tableViewDataSource == ds) return;
	
	tableViewDataSource = ds;
	
	[self dctInternal_setupTableViewDataSource];	
}

- (void)dctInternal_setupTableViewDataSource {	
	self.tableViewDataSource.tableView = self.tableView;
	self.tableViewDataSource.parent = self;
}

- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender {
	self.opened = !self.opened;
}

- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender {
	self.opened = !self.opened;
}

@end
