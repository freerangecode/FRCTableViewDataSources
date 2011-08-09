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
- (void)dctInternal_setupTableViewSectionWithCell:(UITableViewCell *)cell;
@end

@implementation DCTCollapsableSectionTableViewDataSource {
	NSInteger tableViewSection;
}

@synthesize tableView;
@synthesize tableViewDataSource;
@synthesize greyWhenEmpty;
@synthesize title;
@synthesize type;
@synthesize opened;

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	tableViewSection = -1;
	
	return self;	
}

#pragma mark - DCTTableViewDataSource

- (void)reloadData {
	[tableViewDataSource reloadData];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	return [self.tableViewDataSource objectAtIndexPath:ip];
}

#pragma mark - UITableViewDataSource

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
	
	if (tableViewSection < 0) return;
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < [self.tableViewDataSource tableView:self.tableView numberOfRowsInSection:0]; i++)
		[indexPaths addObject:[NSIndexPath indexPathForRow:i+1 inSection:tableViewSection]];
	
	[self.tableView beginUpdates];
	
	if (aBool)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	else
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	
	[self.tableView endUpdates];
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
}

- (IBAction)dctInternal_titleTapped:(UITapGestureRecognizer *)sender {
	
	if (tableViewSection < 0) {
		
		if (![sender.view isKindOfClass:[UITableViewCell class]]) return;
		
		[self dctInternal_setupTableViewSectionWithCell:(UITableViewCell *)sender.view];
	}
	
	self.opened = !self.opened;
}

- (IBAction)dctInternal_disclosureButtonTapped:(UIButton *)sender {
	
	if (tableViewSection < 0) {
		
		UIView *v = sender;
		
		while (![v isKindOfClass:[UITableViewCell class]]) {
			v = [v superview];
		}
		
		[self dctInternal_setupTableViewSectionWithCell:(UITableViewCell *)v];
	}
	
	self.opened = !self.opened;
	
	[UIView beginAnimations:@"some" context:nil];
	[UIView setAnimationDuration:0.33];
	sender.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
	
	
}

- (void)dctInternal_setupTableViewSectionWithCell:(UITableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	tableViewSection = indexPath.section;
}

@end
