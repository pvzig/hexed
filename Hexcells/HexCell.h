//
//  HexCell.h
//  Hexcells
//
//  Created by Peter Zignego on 1/15/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

@interface HexCell : NSObject

@property NSInteger hexIndex;
@property NSInteger hexNumber;
@property NSInteger hexState;

- (id)initWithUniqueId:(NSInteger)hexIndex hexNumber:(NSInteger)hexNumber hexState:(NSInteger)hexState;

@end
