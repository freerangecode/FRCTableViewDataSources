//
//  FRCArrayObservingTableViewDataSource.h
//  NespressoTasting
//
//  Created by Daniel Tull on 24.04.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "FRCTableViewDataSource.h"

@interface FRCArrayObservingTableViewDataSource : FRCTableViewDataSource
- (void)observeArrayInObject:(id)object keyPath:(NSString *)keyPath;
@end
