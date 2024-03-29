/*
 COPYRIGHT 2009 ESRI
 
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



@class AGSSymbol;
@class AGSFillSymbol;
@class AGSSimpleLineSymbol;

/** @file AGSSimpleFillSymbol.h */ //Required for Globals API doc

#pragma mark -

/** Supported fill styles.
 @since 10.2
 */
typedef NS_ENUM(NSInteger, AGSSimpleFillSymbolStyle) {
    AGSSimpleFillSymbolStyleBackwardDiagonal = 0,	/*!< */
    AGSSimpleFillSymbolStyleCross,					/*!< */
    AGSSimpleFillSymbolStyleDiagonalCross,			/*!< */
    AGSSimpleFillSymbolStyleForwardDiagonal,		/*!< */	
    AGSSimpleFillSymbolStyleHorizontal,				/*!< */
    AGSSimpleFillSymbolStyleNull,					/*!< */
    AGSSimpleFillSymbolStyleSolid,					/*!< */
    AGSSimpleFillSymbolStyleVertical				/*!< */
} ;



#pragma mark -

/**  A fill symbol based on simple patterns.
 
 Instances of this class represent simple fill symbols. Symbols describe how 
 graphics look on the map. Different symbols are used for graphics with different 
 geometry types.  Fill symbols are used with graphics which are based 
 on a polygon geometry. The symbol can fill the interior of a polygon graphic
 with a solid color. In addition, the symbol can have 
 an optional outline which is defined by a line symbol.
 
 
 */

@interface AGSSimpleFillSymbol : AGSFillSymbol

/** The fill style. Possible values include
  
 @li  AGSSimpleFillSymbolStyleBackwardDiagonal
 @li  AGSSimpleFillSymbolStyleCross
 @li  AGSSimpleFillSymbolStyleDiagonalCross
 @li  AGSSimpleFillSymbolStyleForwardDiagonal
 @li  AGSSimpleFillSymbolStyleHorizontal
 @li  AGSSimpleFillSymbolStyleNull
 @li  AGSSimpleFillSymbolStyleSolid
 @li  AGSSimpleFillSymbolStyleVertical
 
 Default is AGSSimpleFillSymbolStyleSolid.
 @since 10.2
 */
@property (nonatomic, assign) AGSSimpleFillSymbolStyle style;

/** Initialize an autoreleased symbol.
 @return A new, autoreleased, simple fill symbol object.
 @since 10.2
 */
+ (id)simpleFillSymbol;

/** Initialize a symbol with a fill color and an outline color
 @since 10.2
 */
-(id)initWithColor:(AGSColor*)fillColor outlineColor:(AGSColor*)outlineColor;

/** Initialize an autoreleased symbol with a fill color and an outline color
 @since 10.2
 */
+(AGSSimpleFillSymbol*)simpleFillSymbolWithColor:(AGSColor*)fillColor outlineColor:(AGSColor*)outlineColor;

@end




