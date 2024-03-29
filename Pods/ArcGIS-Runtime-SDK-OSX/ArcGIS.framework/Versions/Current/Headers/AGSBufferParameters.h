/*
 COPYRIGHT 2012 ESRI
 
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

/** @file AGSBufferParameters.h */ //Required for Globals API doc

/**  Parameters for <code>AGSGeometryServiceTask</code>'s 
 <code>bufferWithParameters:</code> operation.
 
 Instances of this class represent parameters for <code>AGSGeometryServiceTask</code>'s 
 <code>bufferWithParameters:</code> operation.
 
 
 */
@interface AGSBufferParameters : NSObject <AGSCoding>

/** The spatial reference in which the geometries should be buffered. If 
 @p bufferSpatialReference is not specified, the geometries are buffered in the 
 spatial reference specified by outSpatialReference. If outSpatialReference is 
 also not specified, they are buffered in their original spatial reference.
 @since 10.2
 */
@property (nonatomic, strong) AGSSpatialReference *bufferSpatialReference;

/** The distances by which the input geometries are to be buffered. The distance 
 units are specified by unit.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *distances;

/** The input geometries to buffer.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *geometries;

/** The spatial reference for the returned geometries. If this is not specified, 
 the output geometries are in the spatial reference specified by 
 bufferSpatialReference. If bufferSpatialReference is also not specified, they 
 are returned in their original spatial reference.
 @since 10.2
 */
@property (nonatomic, strong) AGSSpatialReference *outSpatialReference;

/** If <code>YES</code>, all geometries buffered at a given distance are unioned 
 into a single (possibly multipart) polygon. Default is <code>NO</code>.
 @since 10.2
 */
@property (nonatomic) BOOL unionResults;

/** The units of the buffer distance. Possible values are listed in the 
 documentation for [[esriSRUnitType](http://resources.arcgis.com/en/help/arcobjects-net/componenthelp/index.html //002m00000042000000)] and
 [[esriSRUnit2Type](http://resources.arcgis.com/en/help/arcobjects-net/componenthelp/index.html //002m00000041000000).]
 
 If @p unit is not specified, the units are derived from bufferSpatialReference. 
 If bufferSpatialReference is not specified, the units are derived from the 
 features' spatial reference.
 @since 10.2
 */
@property (nonatomic) AGSSRUnit unit;

/** Returns an autoreleased instance of the <code>%AGSBufferParameters</code> object.
 @since 10.2
 */
+ (id)bufferParameters;

@end
