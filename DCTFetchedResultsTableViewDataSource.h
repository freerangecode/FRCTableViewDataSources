//
//  DCTFetchedResultsTableViewDataSource.h
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 30/05/2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewDataSource.h"
#import <CoreData/CoreData.h>

typedef NSFetchRequest *(^DCTFetchRequestBlock)();

@interface DCTFetchedResultsTableViewDataSource : DCTTableViewDataSource <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, copy) DCTFetchRequestBlock fetchRequestBlock;

- (void)loadFetchRequest;
- (void)loadFetchedResultsController;

@end
