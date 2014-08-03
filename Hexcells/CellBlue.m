//
//  CellBlue.m
//  Hexcells
//
//  Created by Peter Zignego on 1/16/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

#import "CellBlue.h"

@implementation CellBlue

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    //Outermost white hexagon
    [self drawHexagonWithStrokeColor:[UIColor whiteColor] fillColor:[UIColor whiteColor] hexagonSize:27];
    //Outer dark blue hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0] fillColor:[UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0] hexagonSize:25];
    //Inner light blue hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1.0] fillColor:[UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1.0] hexagonSize:20];
}

//CGContext draw
-(void)drawHexagonWithStrokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor hexagonSize:(NSInteger)size {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    NSInteger hexSize = size;
    CGPoint center = CGPointMake(28.87, 25);
    CGContextMoveToPoint(context, center.x + hexSize, center.y);
    for (NSInteger i = 1; i <= 6; ++i) {
        CGFloat x = hexSize *  cosf(i * 2.0 * M_PI / 6);
        CGFloat y = hexSize * sinf(i * 2.0 * M_PI / 6);
        CGContextAddLineToPoint(context, center.x + x, center.y +y);
    }
    CGContextFillPath(context);
    CGContextStrokePath(context);
    UIGraphicsEndImageContext();
}

//CAShapeLayer draw hexagon from center
-(CAShapeLayer*)hexagonWithCenter:(CGPoint)center {
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSInteger size = 12.5;
    [path moveToPoint: CGPointMake(center.x+size, center.y)];
    for(NSInteger i = 1; i <= 6; i++) {
        CGFloat x = size *  cosf(i * 2.0 * M_PI / 6);
        CGFloat y = size * sinf(i * 2.0 * M_PI / 6);
        [path addLineToPoint:CGPointMake(center.x + x, center.y+y)];
        [path stroke];
    }
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:path.CGPath];
    shape.lineWidth = 0;
    shape.strokeColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    shape.fillColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    return shape;
}

// Shatter animation
-(void)performShatterAnimations:(UICollectionViewCell *)cell view:(UIView *)view {
    //Bisected hexagon
    UIGraphicsBeginImageContext(cell.frame.size);
    self.topHex = [[CAShapeLayer alloc] init];
    self.bottomHex = [[CAShapeLayer alloc] init];
    self.leftHex = [[CAShapeLayer alloc] init];
    self.topDiamond = [[CAShapeLayer alloc] init];
    self.bottomDiamond = [[CAShapeLayer alloc] init];
    self.rightDiamond = [[CAShapeLayer alloc] init];
    
    CGPoint center;
    //Left hexagon
    center = CGPointMake(cell.frame.origin.x+16.75, cell.frame.origin.y+25);
    self.leftHex = [self hexagonWithCenter:center];
    //Top hexagon
    center = CGPointMake(cell.frame.origin.x+34.75, cell.frame.origin.y+14.5);
    self.topHex = [self hexagonWithCenter:center];
    //Bottom hexagon
    center = CGPointMake(cell.frame.origin.x+34.75, cell.frame.origin.y+35.5);
    self.bottomHex = [self hexagonWithCenter:center];
    
    [view.layer addSublayer:self.leftHex];
    [view.layer addSublayer:self.topHex];
    [view.layer addSublayer:self.bottomHex];

    //Right diamond
    center = CGPointMake(cell.frame.origin.x+46.75, cell.frame.origin.y+15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x;
    CGFloat y;
    [path moveToPoint: CGPointMake(center.x, center.y)];
    x = center.x+0;
    y = center.y+20.5;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x + 6.25;
    y = y - 20.5/2;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 6.25;
    y = y - 20.5/2;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 6.25;
    y = y + 20.5/2;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x + 6.25;
    y = y + 20.5/2;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    [self.rightDiamond setPath:path.CGPath];
    self.rightDiamond.lineWidth = 0;
    self.rightDiamond.strokeColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    self.rightDiamond.fillColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    
    // Top diamond
    path = [UIBezierPath new];
    center = CGPointMake(cell.frame.origin.x+16.75, cell.frame.origin.y+4);
    [path moveToPoint: CGPointMake(center.x, center.y)];
    x = center.x+11.75;
    y = center.y;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 6;
    y = y + 10.25;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 11.75;
    y = y;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x + 6;
    y = y - 10.25;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    [self.topDiamond setPath:path.CGPath];
    self.topDiamond.lineWidth = 0;
    self.topDiamond.strokeColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    self.topDiamond.fillColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    
    // Bottom diamond
    path = [UIBezierPath new];
    center = CGPointMake(cell.frame.origin.x+10.75, cell.frame.origin.y+35.5);
    [path moveToPoint: CGPointMake(center.x, center.y)];
    x = center.x+6;
    y = center.y+10.25;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x + 11.75;
    y = y;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 6;
    y = y - 10.25;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    x = x - 11.75;
    y = y;
    [path addLineToPoint:CGPointMake(x, y)];
    [path stroke];
    [self.bottomDiamond setPath:path.CGPath];
    self.bottomDiamond.lineWidth = 0;
    self.bottomDiamond.strokeColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    self.bottomDiamond.fillColor = [UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0].CGColor;
    
    [view.layer addSublayer:self.rightDiamond];
    [view.layer addSublayer:self.topDiamond];
    [view.layer addSublayer:self.bottomDiamond];
    UIGraphicsEndImageContext();
    
    // Animate
    CAShapeLayer *activeLayer = [[CAShapeLayer alloc] init];
    NSArray *layerArray = [[NSArray alloc] initWithObjects:self.topHex,self.bottomHex,self.leftHex,self.topDiamond,self.bottomDiamond,self.rightDiamond, nil];
    for (int i=0; i <layerArray.count; i++) {
        activeLayer = [layerArray objectAtIndex:i];
        //Scatter
        CGPoint startPoint = CGPointMake(activeLayer.frame.origin.x+activeLayer.frame.size.width/2, activeLayer.frame.origin.y+activeLayer.frame.size.height/2);
        NSInteger range = 150 - -150;
        NSInteger randomNumber = (arc4random() % range) + -150;
        CGPoint controlPoint;
        if (cell.frame.origin.x < view.frame.size.width/2) {
            controlPoint = CGPointMake(cell.frame.origin.x-100+randomNumber, startPoint.y-50);
        }
        if (cell.frame.origin.x >= view.frame.size.width/2) {
            controlPoint = CGPointMake(cell.frame.origin.x-300+randomNumber, startPoint.y-50);
        }
        CGPoint endPoint = CGPointMake(cell.frame.origin.x+randomNumber, view.frame.size.height);
        
        UIBezierPath *trackPath = [UIBezierPath bezierPath];
        [trackPath moveToPoint:startPoint];
        [trackPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
        
        activeLayer.position = cell.layer.position;
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        anim.delegate = self;
        anim.path = trackPath.CGPath;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.repeatCount = 0;
        anim.duration = 2;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        
        //Scale
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.delegate = self;
        animation.fromValue = [NSNumber numberWithFloat:1.00];
        animation.toValue = [NSNumber numberWithFloat:0.0];
        animation.duration = 2;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        //Perform animations
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations:[NSArray arrayWithObjects:anim, animation, nil]];
        [animationGroup setDuration:2.0];
        [animationGroup setRemovedOnCompletion:NO];
        [animationGroup setFillMode:kCAFillModeForwards];
        [activeLayer addAnimation:animationGroup forKey:nil];
    }
}

// Remove animation layers on completion
-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (flag) {
        [self.topHex removeFromSuperlayer];
        [self.bottomHex  removeFromSuperlayer];
        [self.leftHex  removeFromSuperlayer];
        [self.topDiamond  removeFromSuperlayer];
        [self.bottomDiamond  removeFromSuperlayer];
        [self.rightDiamond  removeFromSuperlayer];
    }
}

//For beaten levels on the level select screen
-(void)numbered:(NSInteger)number cell:(UICollectionViewCell*)cell index:(NSIndexPath *)index {
    //Number label
    if (number > 2) {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.5, -1, cell.frame.size.width, cell.frame.size.height)];
        NSString *numberString = [@(number) stringValue];
        NSMutableString *levelString = [NSMutableString stringWithString:numberString];
        [levelString insertString:@"-" atIndex:1];
        numberLabel.text = levelString;
        numberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        numberLabel.textColor = [UIColor whiteColor];
        [cell addSubview:numberLabel];
    }
}

@end
