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

@class AGSTiledServiceLayer;
@class AGSSpatialReference;
@class AGSEnvelope;
@class AGSTileInfo;

/** @file AGSBingMapLayer.h */

/** Supported map styles for BingMaps.
 @since 10.2
 */
typedef NS_ENUM(NSInteger, AGSBingMapLayerStyle) { 
	AGSBingMapLayerStyleAerial,				/*!<  */
	AGSBingMapLayerStyleAerialWithLabels,	/*!<  */
	AGSBingMapLayerStyleRoad				/*!<  */
} ;

/**  A layer based on Bing Maps.
 
 An instance of this class allows you display maps from Bing Maps.
 

 
 */
@interface AGSBingMapLayer : AGSTiledServiceLayer

/** Spatial Reference used by Bing Maps.
 @since 10.2
 */
@property (nonatomic, strong, readonly) AGSSpatialReference *spatialReference;

/** Full extent of Bing Maps.
 @since 10.2
 */
@property (nonatomic, strong, readonly) AGSEnvelope *fullEnvelope;

/** Tiling scheme used by Bing Maps.
 @since 10.2
 */
@property (nonatomic, strong, readonly) AGSTileInfo *tileInfo;

/** An AppID which has been authorized to use Bing Maps.
 @since 10.2
 @see [Getting Started with Bing API](http://msdn.microsoft.com/en-us/library/b80e6336-6a33-4555-b26a-ba834c8d756c)
 */
@property (nonatomic, copy, readonly) NSString *appID;

/** The map style. Possible values include 
 
 @li  AGSBingMapLayerStyleAerial
 @li  AGSBingMapLayerStyleAerialWithLabels
 @li  AGSBingMapLayerStyleRoad
 
 @since 10.2
 */
@property (nonatomic, assign) AGSBingMapLayerStyle style;

/** The locale to use for the Bing Map service.
 The default is the current locale of the device.
 @since 10.2
 */
@property (nonatomic, strong) NSLocale *locale;

/** Initialize this layer with an AppID and a map style.
 @param appID The appID authorized to use Bing Maps.
 @param style The style of the map. See style.
 @return A new Bing Maps layer object.
 @since 10.2
 @see AGSBingMapLayerStyle
 @see  [AGSLayerDelegate layerDidLoad:] , method on delegate for success
 @see  [AGSLayerDelegate layer:didFailToLoadWithError:] , method on delegate for failure

 */
-(id)initWithAppID: (NSString*) appID style:(AGSBingMapLayerStyle) style;

@end






