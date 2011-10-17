//
//  MasterViewController.m
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 12.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FRCSplitTableViewDataSource.h"
#import "FRCFetchedResultsTableViewDataSource.h"
#import "FRCObjectTableViewDataSource.h"
#import "Event.h"
#import "EventTableViewCell.h"
#import "AddTableViewCell.h"

@interface MasterViewController ()
- (void)saveContext;
- (IBAction)insertNewEvent:(id)sender;
@end

@implementation MasterViewController {
	__strong FRCSplitTableViewDataSource *splitDataSource;
	__strong FRCObjectTableViewDataSource *addingDataSource;
}

@synthesize managedObjectContext;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	splitDataSource = [[FRCSplitTableViewDataSource alloc] init];
	splitDataSource.type = FRCSplitTableViewDataSourceTypeSection;
	
	
	addingDataSource = [[FRCObjectTableViewDataSource alloc] init];
	addingDataSource.object = @"Add new timestamp";
	addingDataSource.cellClass = [AddTableViewCell class];
	[splitDataSource addChildTableViewDataSource:addingDataSource];
	
	
	FRCFetchedResultsTableViewDataSource *fetchedResultsDS = [[FRCFetchedResultsTableViewDataSource alloc] init];
	fetchedResultsDS.cellClass = [EventTableViewCell class];
	fetchedResultsDS.managedObjectContext = self.managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[Event entityInManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:EventAttributes.timeStamp ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchBatchSize:20];
	fetchedResultsDS.fetchRequest = request;
	
	[splitDataSource addChildTableViewDataSource:fetchedResultsDS];
	
	self.tableView.dataSource = splitDataSource;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = [splitDataSource objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:selectedObject];
    }
}

#pragma mark - MasterViewController

- (IBAction)insertNewEvent:(id)sender {
	
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:[Event entityName]
													inManagedObjectContext:self.managedObjectContext];
	newEvent.timeStamp = [NSDate date];
	
	[self saveContext];
}

- (void)saveContext {
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	id object = [splitDataSource objectAtIndexPath:indexPath];
	
	if (![object isEqual:addingDataSource.object]) return;
	
	[self insertNewEvent:self];
}

@end
