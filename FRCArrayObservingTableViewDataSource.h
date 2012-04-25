//
//  FRCArrayObservingTableViewDataSource.h
//  NespressoTasting
//
//  Created by Daniel Tull on 24.04.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "FRCTableViewDataSource.h"

@interface FRCArrayObservingTableViewDataSource : FRCTableViewDataSource

- (id)initWithObject:(id)object arrayKeyPath:(NSString *)keyPath;

@property (nonatomic, readonly, strong) id object;
@property (nonatomic, readonly, copy) NSString *keyPath;

@end
