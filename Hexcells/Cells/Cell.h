//
//  Cell.h
//  Hexcells
//
//  Created by Peter Zignego on 1/13/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

@interface Cell : UICollectionViewCell

-(void)numbered:(NSInteger)number cell:(UICollectionViewCell*)cell index:(NSIndexPath *)index;
-(void)performSelectionAnimations:(UICollectionViewCell *)cell view:(UIView *)view;

@property CAShapeLayer *outerHex;
@property CAShapeLayer *innerOrangeHex;
@property CAShapeLayer *hex;

@end
