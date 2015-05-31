//
//  CellGray.h
//  Hexcells
//
//  Created by Peter Zignego on 1/16/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

@interface CellGray : UICollectionViewCell

-(void)numbered:(NSInteger)number cell:(UICollectionViewCell*)cell index:(NSIndexPath *)index;

@property UILabel *numberLabel;

@end
