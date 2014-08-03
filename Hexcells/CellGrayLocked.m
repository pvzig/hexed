//
//  CellGrayLocked.m
//  Hexcells
//
//  Created by Peter Zignego on 1/21/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "CellGrayLocked.h"

@implementation CellGrayLocked

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    //Outermost white hexagon
    [self drawHexagonWithStrokeColor:[UIColor whiteColor] fillColor:[UIColor whiteColor] hexagonSize:27];
    //Outer dark gray hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.17 green:0.18 blue:0.20 alpha:1.0] fillColor:[UIColor colorWithRed:0.17 green:0.18 blue:0.20 alpha:1.0] hexagonSize:25];
    //Inner light gray hexagon
    [self drawHexagonWithStrokeColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1.0] fillColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.25 alpha:1.0] hexagonSize:20];
    
    // Lock, generated with Code Paint
    //// Color Declarations
    UIColor *color = [UIColor colorWithRed: 0.18 green: 0.18 blue: 0.18 alpha: 1];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(21, 23, 15, 12) cornerRadius: 1];
    [color setFill];
    [roundedRectanglePath fill];
    [color setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(25, 25.5)];
    [bezierPath addCurveToPoint: CGPointMake(29, 13.5) controlPoint1: CGPointMake(25, 12.5) controlPoint2: CGPointMake(23, 13.5)];
    bezierPath.lineJoinStyle = kCGLineJoinBevel;
    
    [color setStroke];
    bezierPath.lineWidth = 3;
    [bezierPath stroke];

    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(33, 25.5)];
    [bezier2Path addCurveToPoint: CGPointMake(29, 13.5) controlPoint1: CGPointMake(33, 12.5) controlPoint2: CGPointMake(35, 13.5)];
    bezier2Path.lineJoinStyle = kCGLineJoinBevel;
    [color setStroke];
    bezier2Path.lineWidth = 3;
    [bezier2Path stroke];
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

@end
