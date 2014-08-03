//
//  Cell.m
//  Hexcells
//
//  Created by Peter Zignego on 1/13/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//Custom draw, 3 hexagons with the same center point
-(void)drawRect:(CGRect)rect {
    //Outermost white hexagon
    [self drawHexagonWithStrokeColor:[UIColor whiteColor] fillColor:[UIColor whiteColor] hexagonSize:27];
    //Outer dark orange hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.95 green:0.63 blue:0.2 alpha:1] fillColor: [UIColor colorWithRed:0.95 green:0.63 blue:0.2 alpha:1] hexagonSize:25];
    //Inner light orange hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.96 green:0.69 blue:0.26 alpha:1] fillColor:[UIColor colorWithRed:0.96 green:0.69 blue:0.26 alpha:1] hexagonSize:20];
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

//CALayer draw
-(CAShapeLayer*)CAShapeLayerHexagon:(CAShapeLayer*)layer forCell: (UICollectionViewCell*)cell withStrokeColor:(UIColor*)strokeColor lineWidth:(NSInteger)width fillColor:(UIColor*)fillColor hexagonSize:(NSInteger)size {
    CGPoint center = CGPointMake(cell.frame.origin.x+28.87, cell.frame.origin.y+25);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(center.x + size, center.y)];
    //Animates
    if (layer == self.hex) {
        for (NSInteger t = 0; t<=20; t++) {
            size = size - 1;
            for(NSInteger i = 1; i <= 20; i++) {
                CGFloat x = size *  cosf(i * 2.0 * M_PI / 6);
                CGFloat y = size * sinf(i * 2.0 * M_PI / 6);
                [path addLineToPoint:CGPointMake(center.x +x, center.y+y)];
                [path stroke];
            }
        }
    }
    //Draws
    else {
        for (NSInteger i = 1; i <= 6; i++) {
            CGFloat x = size *  cosf(i * 2.0 * M_PI / 6);
            CGFloat y = size * sinf(i * 2.0 * M_PI / 6);
            [path addLineToPoint:CGPointMake(center.x + x, center.y + y)];
            [path stroke];
        }
    }
    [layer setPath:path.CGPath];
    layer.lineWidth = width;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = fillColor.CGColor;
    return layer;
}

// Fill animation
-(void)performSelectionAnimations:(UICollectionViewCell *)cell view:(UIView *)view {
    UIGraphicsBeginImageContext(cell.frame.size);
    
    self.hex = [CAShapeLayer layer];
    self.outerHex = [CAShapeLayer layer];
    self.innerOrangeHex = [CAShapeLayer layer];
    
    self.outerHex = [self CAShapeLayerHexagon:self.outerHex forCell:cell withStrokeColor:[UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0] lineWidth:0 fillColor:[UIColor colorWithRed:0.26 green:0.62 blue:0.84 alpha:1.0] hexagonSize:25];
    self.innerOrangeHex = [self CAShapeLayerHexagon:self.innerOrangeHex forCell:cell withStrokeColor:[UIColor colorWithRed:0.96 green:0.69 blue:0.26 alpha:1] lineWidth:0 fillColor:[UIColor colorWithRed:0.96 green:0.69 blue:0.26 alpha:1] hexagonSize:19];
    self.hex = [self CAShapeLayerHexagon:self.hex forCell:cell withStrokeColor:[UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1.0] lineWidth:1 fillColor:[UIColor clearColor] hexagonSize:20];
    
    // Add to parent layer
    [view.layer addSublayer:self.outerHex];
    [self.outerHex addSublayer:self.innerOrangeHex];
    [self.outerHex addSublayer:self.hex];
    
    // Configure animation
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.delegate = self;
    fillAnimation.duration = .10;
    fillAnimation.repeatCount = 1.0;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    fillAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fillAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Add the animation
    [self.hex addAnimation:fillAnimation forKey:nil];
    UIGraphicsEndImageContext();
}

// Remove animation layers on completion
-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (flag) {
        [self.outerHex removeFromSuperlayer];
    }
}

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
