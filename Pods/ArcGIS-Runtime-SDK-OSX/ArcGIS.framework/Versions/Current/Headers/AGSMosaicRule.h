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

/** @file AGSMosaicRule.h */

@class AGSPoint;

/**  Defines how individual images should be mosaicked.
 
 Specifies the mosaic rule when defining how individual images should be
 mosaicked. It specifies selection, mosaic method, sort order, overlapping pixel
 resolution, etc. Mosaic rules are for mosaicking rasters in the mosaic dataset.
 A mosaic rule is used to define:
	- The selection of rasters that will participate in the mosaic (using the where clause).
	- The mosaic method, e.g. how the selected rasters are ordered.
	- The mosaic operation, e.g. how overlapping pixels at the same location are resolved.
 
 
 */
@interface AGSMosaicRule : NSObject <AGSCoding>

/** Indicates whether the sort should be ascending or not.
 @since 10.2
 */
@property (nonatomic, assign) BOOL ascending;

/** An array of raster Ids. All the rasters with the given list of raster Ids are
 selected to participate in the mosaic. The rasters will be visible at all pixel
 sizes regardless of the minimum and maximum pixel size range of the locked rasters.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *lockRasterIds;

/** The mosaic method determines how the selected rasters are ordered. See
  AGSMosaicMethod for a list of valid values.
 @since 10.2
 */
@property (nonatomic, assign) AGSMosaicMethod method;

/** Defines a selection using a set of ObjectIds. This property applies to all 
 mosaic methods.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *objectIds;

/** Defines the mosaic operation used to resolve overlapping pixels. See 
 AGSMosaicOperationType for a list of valid values.
 @since 10.2
 */
@property (nonatomic, assign) AGSMosaicOperationType operation;

/** The name of the attribute field that is used together with a constant @p sortValue
 to define the mosaicking order when the mosaic method is set to @p AGSMosaicMethodAttribute.
 @since 10.2
 */
@property (nonatomic, copy) NSString *sortField;

/** A constant value defining a reference or base value for the sort field when the 
 mosaic method is set to @p AGSMosaicMethodAttribute.
 @since 10.2
 */
@property (nonatomic, copy) NSString *sortValue;

/** Defines the viewpoint location on which the ordering is defined based on the
 distance from the viewpoint and the nadir of rasters.
 @since 10.2
 */
@property (nonatomic, strong) AGSPoint *viewpoint;

/** The where clause determines which rasters will participate in the mosaic. This
 property applies to all mosaic methods.
 @since 10.2
 @deprecated Deprecated at 10.2.4. Please use  [AGSMosaicRule whereClause] instead.
 */
@property (nonatomic, copy) NSString *where __attribute__((deprecated));

/** The where clause determines which rasters will participate in the mosaic. This
 property applies to all mosaic methods.
 @since 10.2.4
 */
@property (nonatomic, copy) NSString *whereClause;

@end
