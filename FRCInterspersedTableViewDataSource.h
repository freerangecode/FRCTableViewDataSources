//
//  FRCInterspersedTableViewDataSource.h
//  Tweetville
//
//  Created by Daniel Tull on 23.05.2012.
//  Copyright (c) 2012 Daniel Tull Limited. All rights reserved.
//

#import "FRCParentTableViewDataSource.h"

@interface FRCInterspersedTableViewDataSource : FRCParentTableViewDataSource
/** The child data source to intersperse.
 */
@property (nonatomic, strong) FRCTableViewDataSource *childTableViewDataSource;
@property (nonatomic, assign) Class interspersedCellClass;
@property (nonatomic, assign) BOOL showInterspersedCellOnTop;
@property (nonatomic, assign) BOOL showInterspersedCellOnBottom;

@end
