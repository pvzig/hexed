//
//  HexCell.m
//  Hexcells
//
//  Created by Peter Zignego on 1/15/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "HexCell.h"

@implementation HexCell

- (id)initWithUniqueId:(NSInteger)hexIndex hexNumber:(NSInteger)hexNumber hexState:(NSInteger)hexState {
    if ((self = [super init])) {
        self.hexIndex = hexIndex;
        self.hexNumber = hexNumber;
        self.hexState = hexState;
    }
    return self;
}

@end
