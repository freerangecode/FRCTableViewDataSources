/*
 DCTTableViewSectionController.m
 DCTUIKit
 
 Created by Daniel Tull on 16.09.2010.
 
 
 
 Copyright (c) 2010 Daniel Tull. All rights reserved.
 
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

#import "DCTTableViewSectionController.h"
#import <QuartzCore/QuartzCore.h>

@interface DCTTableViewSectionController ()
- (NSIndexPath *)dctInternal_fetchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)dctInternal_tableViewIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath;
- (BOOL)dctInternal_indexPathIsTitleCell:(NSIndexPath *)indexPath;
- (UIButton *)dctInternal_disclosureButton;
@end

@implementation DCTTableViewSectionController

@synthesize tableView, section, fetchedResultsController, opened, delegate, sectionTitle;

#pragma mark -
#pragma mark NSObject methods

- (void)dealloc {
    [tableView release], tableView = nil;
	[fetchedResultsController release], fetchedResultsController = nil;
	[sectionTitle release], sectionTitle = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark DCTTableViewSectionController methods

- (id)objectForTableViewIndexPath:(NSIndexPath *)tvIndexPath {
	NSIndexPath *frcIndexPath = [self dctInternal_fetchedResultsControllerIndexPathFromTableViewIndexPath:tvIndexPath];
	
	if (!frcIndexPath) return nil;
	
	return [self.fetchedResultsController objectAtIndexPath:frcIndexPath];
}

- (void)checkButtonTapped:(UIButton *)sender event:(id)event {
	
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
	layer.transform = CATransform3DMakeRotation(self.opened ? M_PI : 0.0, 0.0, 0.0, 1.0);
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)s {
	
	if (!opened) return 1;
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([self dctInternal_indexPathIsTitleCell:indexPath]) {
		
		NSString *identifier = [NSString stringWithFormat:@"%@-title", self.sectionTitle];
		
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
		
		if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		
		cell.textLabel.text = self.sectionTitle;
		cell.accessoryView = [self dctInternal_disclosureButton];
		
		if (self.opened) cell.accessoryView.layer.transform = CATransform3DMakeRotation(self.opened ? M_PI : 0.0, 0.0, 0.0, 1.0);
		
		return cell;
	}
	
	NSString *identifier = [NSString stringWithFormat:@"%@-cell", self.sectionTitle];
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
	
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	cell.indentationLevel = 1;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	
	NSManagedObject *mo = [self objectForTableViewIndexPath:indexPath];
	
	if ([self.delegate respondsToSelector:@selector(sectionController:titleForObject:)])
		cell.textLabel.text = [self.delegate sectionController:self titleForObject:mo];
	
	return  cell;	
}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	if (!opened) return;
	
	[self.tableView endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	
	if (!opened) return;
	
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (!opened) return;
	
	UITableView *tv = self.tableView;
	
	NSIndexPath *tvIndexPath = [self dctInternal_tableViewIndexPathFromFetchedResultsControllerIndexPath:indexPath];
	NSIndexPath *tvNewIndexPath = [self dctInternal_tableViewIndexPathFromFetchedResultsControllerIndexPath:newIndexPath];
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:tvNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:tvIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tvIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
			
        case NSFetchedResultsChangeMove:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:tvIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:tvNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


#pragma mark -
#pragma mark Private methods

- (NSIndexPath *)dctInternal_fetchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) return nil;
	
	return [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0];
}

- (NSIndexPath *)dctInternal_tableViewIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath {
	return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:self.section];
}

- (BOOL)dctInternal_indexPathIsTitleCell:(NSIndexPath *)indexPath {
	return (indexPath.row == 0);
}

- (UIButton *)dctInternal_disclosureButton {
	UIImage *image = [UIImage imageNamed:@"DisclosureArrow.png"];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);	
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	return button;
}

@end
