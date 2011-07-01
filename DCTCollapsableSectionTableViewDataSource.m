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
@end

@implementation DCTCollapsableSectionTableViewDataSource {
	BOOL opened;
}

@synthesize tableView;
@synthesize tableViewDataSource;
@synthesize sectionController;
@synthesize greyWhenEmpty;
@synthesize title;
@synthesize type;
@synthesize opened;

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	
	NSInteger numberOfRows = 0;
	
	if (self.opened) numberOfRows = [self.tableViewDataSource tableView:tv numberOfRowsInSection:section];
	
	return numberOfRows + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		
		NSString *identifier = [NSString stringWithFormat:@"titleCell"];
		
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		
		cell.textLabel.text = self.title;
		
		if (self.type == DCTCollapsableSectionTableViewDataSourceTypeCell) {
			
			UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped:)]; 
			[cell addGestureRecognizer:gr];

		} else if (self.type == DCTCollapsableSectionTableViewDataSourceTypeDisclosure) {
			
			UIImage *image = [UIImage imageNamed:@"DisclosureArrow.png"];
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);	
			[button setBackgroundImage:image forState:UIControlStateNormal];
			[button addTarget:self action:@selector(disclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			button.backgroundColor = [UIColor clearColor];
			cell.accessoryView = button;
		}
		
		/*
		if (self.greyWhenEmpty && [self.tableViewDataSource tableView:tv numberOfRowsInSection:indexPath.section] == 0) {
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else {
			//cell.accessoryView = [self dctInternal_disclosureButton];
			
			//if (self.opened) 
			//	cell.accessoryView.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);	
		}*/
		
		return cell;
		
	}
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	
	return [self.tableViewDataSource tableView:tv cellForRowAtIndexPath:ip];
}

- (IBAction)titleTapped:(UITapGestureRecognizer *)sender {
	self.opened = !self.opened;
}

- (void)setOpened:(BOOL)aBool {
	
	if (opened == aBool) return;
	
	opened = aBool;
	
	NSUInteger section = [self.sectionController.tableViewDataSources indexOfObject:self];
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < [self.tableViewDataSource tableView:self.tableView numberOfRowsInSection:0]; i++)
		[indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:section]];
	
	[self.tableView beginUpdates];
	
	if (aBool)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	else
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self.tableView endUpdates];
}

- (IBAction)disclosureButtonTapped:(UIButton *)button {
	
	self.opened = !self.opened;
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	button.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
	
	
}

/*- (void)checkButtonTapped:(UIButton *)sender event:(id)event {
	
	self.opened = !self.opened;
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSInteger numberOfObjects = [sectionInfo numberOfObjects];
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < numberOfObjects; i++)
		[indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:self.section]];
	
	[self.tableView beginUpdates];
	
	if (opened)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	else
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView endUpdates];
	[indexPaths release];
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	CALayer *layer = sender.layer;
	layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
}*/

- (UIButton *)dctInternal_disclosureButton {
	UIImage *image = [UIImage imageNamed:@"DisclosureArrow.png"];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);	
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(disclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	return button;
}

- (void)setTableView:(UITableView *)tv {
	
	if (tv == self.tableView) return;
	
	tableView = tv;
	
	[self dctInternal_setupTableViewDataSource];
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)ds {
	
	if (self.tableViewDataSource == ds) return;
	
	tableViewDataSource = ds;
	
	[self dctInternal_setupTableViewDataSource];	
}

- (void)dctInternal_setupTableViewDataSource {
	
	SEL setTableViewSelector = @selector(setTableView:);
	if ([self.tableViewDataSource respondsToSelector:setTableViewSelector])
		[self.tableViewDataSource performSelector:setTableViewSelector withObject:self.tableView];
	
}

@end
