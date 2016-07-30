/*
 COPYRIGHT 2013 ESRI
 
 TRADE SECRETS: ESRI PROPRIETARY AND CONFIDENTIAL
 Unpublished material - all rights reserved under the
 Copyright Laws of the United States and applicable international
 laws, treaties, and conventions.
 
 For additional information, contact:
 Environmental Systems Research Institute, Inc.
 Attn: Contracts and Legal Services Department
 380 New York Street
 Redlands, California, 92373
 USA
 
 email: contracts@esri.com
 */

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

typedef NS_OPTIONS(NSUInteger, NSBezierPathRoundedCorner) {
    NSBezierPathRoundedCornerNone = 0,
    NSBezierPathRoundedCornerTopLeft = 1,
    NSBezierPathRoundedCornerBottomLeft = 2,
    NSBezierPathRoundedCornerBottomRight = 4,
    NSBezierPathRoundedCornerTopRight = 8,
} ;

CGPathRef AGSCGPathCreateFromBezier(NSBezierPath *bpath);

@interface NSBezierPath (AGSAdditions)
+ (NSBezierPath *)ags_bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)ags_bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerFlags:(NSUInteger)whichCorners;
- (void)ags_appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius cornerFlags:(NSUInteger)whichCorners;
@end
