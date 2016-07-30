/*
 COPYRIGHT 2010 ESRI
 
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



@class AGSSpatialReference;
@class AGSGeometry;
@class AGSEnvelope;
@class AGSTimeExtent;

/** @file AGSImageParameters.h */ //Required for Globals API doc

/**  The parameters to be used when exporting a map image.
 
 Instances of this class represent the parameter options used when exporting 
 a map image by sending the <code>queryResultImage</code> message to an
  AGSGeoprocessor object.
 
 @since 10.2
 */
@interface AGSImageParameters : NSObject

/** Extent of the map to be exported.
 @since 10.2
 */
@property (nonatomic, strong) AGSEnvelope *bbox;

/** Dots per inch setting for an image to render on the device.
 @since 10.2
 */
@property (nonatomic) NSUInteger dpi;

/** Map image format.
 @since 10.2
 */
@property (nonatomic, copy) NSString *format;

/** Requested image height in pixels.
 @since 10.2
 */
@property (nonatomic) NSUInteger height;

/** Spatial reference of exported map.
 @since 10.2
 */
@property (nonatomic, strong) AGSSpatialReference *imageSpatialReference;

/** A list of layer ID's, that represent which layers to include in the exported 
 map. 
 @since 10.2
 */
@property (nonatomic, copy) NSArray *layerIds;
 
/** Whether or not background of dynamic image is transparent.
 @since 10.2
 */
@property (nonatomic, assign) BOOL transparent;

/** Requested image width in pixels.
 @since 10.2
 */
@property (nonatomic) NSUInteger width;

/**
 @since 10.2
 */
@property (nonatomic, strong) AGSTimeExtent *timeExtent;

/**
 @since 10.2
 */
@property (nonatomic, copy) NSArray *layerTimeOptions;

/** Method to encode the parameters into a JSON dictionary.
 @since 10.2
 */
- (NSDictionary *)encodeToJSON;

@end
