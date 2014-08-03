//
//  CellBlue.h
//  Hexcells
//
//  Created by Peter Zignego on 1/16/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

@interface CellBlue : UICollectionViewCell

-(void)numbered:(NSInteger)number cell:(UICollectionViewCell*)cell index:(NSIndexPath *)index;
-(void)performShatterAnimations:(UICollectionViewCell *)cell view:(UIView *)view;

@property CAShapeLayer *topHex;
@property CAShapeLayer *bottomHex;
@property CAShapeLayer *leftHex;
@property CAShapeLayer *topDiamond;
@property CAShapeLayer *bottomDiamond;
@property CAShapeLayer *rightDiamond;

@end
