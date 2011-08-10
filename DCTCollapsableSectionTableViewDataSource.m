//
//  DCTCollapsableSectionTableViewDataSource.m
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTCollapsableSectionTableViewDataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface DCTCollapsableSectionTableViewDataSource ()
- (void)dctInternal_setupTableViewDataSource;
- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender;
- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender;
@end

@implementation DCTCollapsableSectionTableViewDataSource {
	__strong NSString *tableViewCellIdentifier;
	__weak id<DCTTableViewDataSourceParent> parent;
}

@synthesize tableView;
@synthesize tableViewDataSource;
@synthesize greyWhenEmpty;
@synthesize title;
@synthesize type;
@synthesize opened;
@synthesize parent;

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	[tableViewDataSource reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.tableViewDataSource objectAtIndexPath:ip];
}

#pragma mark - DCTTableViewDataSourceParent

- (NSIndexPath *)tableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewIndexPathForDataIndexPath:(NSIndexPath *)indexPath {
	
	indexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
	
	if (self.parent == nil) return indexPath;	
	
	return [self.parent tableViewDataSource:self tableViewIndexPathForDataIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	
	NSInteger numberOfRows = 0;
	
	if (self.opened) numberOfRows = [self.tableViewDataSource tableView:tv numberOfRowsInSection:section];
	
	return numberOfRows + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		
		if (tableViewCellIdentifier == nil) 
			tableViewCellIdentifier = NSStringFromClass([self class]);
		
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
		
		cell.textLabel.text = self.title;
		cell.accessoryView = nil;
		
		if (self.type == DCTCollapsableSectionTableViewDataSourceTypeCell) {
			
			UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dctInternal_titleTapped:)]; 
			[cell addGestureRecognizer:gr];

		} else if (self.type == DCTCollapsableSectionTableViewDataSourceTypeDisclosure) {
			
			UIImage *image = [UIImage imageNamed:@"DCTCollapsableSectionTableViewDataSourceDisclosureButton.png"];
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);	
			[button setBackgroundImage:image forState:UIControlStateNormal];
			[button addTarget:self action:@selector(dctInternal_disclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			button.backgroundColor = [UIColor clearColor];
			button.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
			cell.accessoryView = button;
		}
		
		return cell;
		
	}
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	
	return [self.tableViewDataSource tableView:tv cellForRowAtIndexPath:ip];
}

- (void)setOpened:(BOOL)aBool {
	
	if (opened == aBool) return;
	
	opened = aBool;
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < [self.tableViewDataSource tableView:self.tableView numberOfRowsInSection:0]; i++) {
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i+1 inSection:0];
		if (self.parent != nil) ip = [self.parent tableViewDataSource:self tableViewIndexPathForDataIndexPath:ip];
		[indexPaths addObject:ip];
	}
	
	if ([indexPaths count] == 0) return;
	
	[self.tableView beginUpdates];
	
	if (aBool)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	else
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self.tableView endUpdates];
	
	if (aBool) {
		[self.tableView scrollToRowAtIndexPath:[indexPaths objectAtIndex:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[self.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

- (void)setTableView:(UITableView *)tv {
	
	if (tv == self.tableView) return;
	
	tableView = tv;
	
	[self dctInternal_setupTableViewDataSource];
}

- (void)setTableViewDataSource:(id<DCTTableViewDataSource>)ds {
	
	if (self.tableViewDataSource == ds) return;
	
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
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	sender.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
}

@end
