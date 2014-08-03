//
//  CellGray.m
//  Hexcells
//
//  Created by Peter Zignego on 1/16/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "CellGray.h"

@implementation CellGray

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.numberLabel = [[UILabel alloc] init];
        [self addSubview:self.numberLabel];
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

-(void)numbered:(NSInteger)number cell:(UICollectionViewCell*)cell index:(NSIndexPath *)index {
    self.numberLabel.frame = CGRectMake(23, -1, cell.frame.size.width, cell.frame.size.height);
    self.numberLabel.text = [@(number) stringValue];
    self.numberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    self.numberLabel.textColor = [UIColor whiteColor];
}

@end
