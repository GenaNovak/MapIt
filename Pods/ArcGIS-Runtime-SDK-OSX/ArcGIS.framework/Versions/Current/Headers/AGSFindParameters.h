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

/** @file AGSFindParameters.h */ //Required for Globals API doc


/**  Parameters for an  AGSFindTask operation.
 
 Instances of this class represent parameters for  AGSFindTask operations. 
 Parameters provide criteria for performing a search on the map service. 
 Parameters are passed as an argument to executeWithParameters: on  AGSFindTask.
 
 
 */
@interface AGSFindParameters : NSObject <AGSCoding>

/** If <code>NO</code>,  AGSFindTask searches for an <i>exact match</i> of 
 searchText and in a case sensitive manner. Otherwise, it searches for a value 
 that <i>contains</i> the searchText and in a case agnostic manner.
 Default is <code>YES</code>.
 @since 10.2
 */
@property (nonatomic) BOOL contains;

/** The IDs of layers to to be searched. This parameter must be specified.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *layerIds;

/** The spatial reference of the result geometries. By default, geometries 
 are returned in the spatial reference of the map service.
 @since 10.2
 */
@property (nonatomic, strong) AGSSpatialReference *outSpatialReference;

/** Whether or not the returned results should contain geometries. By default, 
 geometries are returned. You can reduce the size of the result payload by 
 excluding the geometries if you don't intend to display those results on the map.
 @since 10.2
 */
@property (nonatomic) BOOL returnGeometry;

/** The names of fields to be searched. If this parameter is not specified, all 
 fields are searched.
 @since 10.2 
 */
@property (nonatomic, copy) NSArray *searchFields;

/** The text to be searched.
 @since 10.2
 */
@property (nonatomic, copy) NSString *searchText;

/** Array of  AGSLayerDefinition objects that allows you to filter the features 
 of individual layers. Definition expressions for layers that are currently not 
 visible will be ignored by the server.
 @note This feature is only available for ArcGIS services v10.0 or greater.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *layerDefinitions;

/** The maximum allowable offset used for generalizing geometries returned by 
 the query operation. The default is 0. If 0 is specified the value is not passed 
 to the server in a query. The offset is in the units of the spatial reference. 
 If a spatial reference is not defined the spatial reference of the map is used.
 @note This feature is only available for ArcGIS services v10.0 or greater.
 @since 10.2
 */
@property (nonatomic, assign) double maxAllowableOffset;

/** A collection of  AGSDynamicLayerInfo objects for one or more sub-layers of a dynamic map service.
 If dynamicLayers is used in a find operation request, layerDefs and layers (find) operation parameters
 are ignored. Instead, use definitionExpression available within dynamicLayers to specify these values
 in the find operation. Only those layers that are defined in dynamicLayers are used in the find operation.
 @since 10.2.4
 */
@property (nonatomic, copy, readwrite) NSArray *dynamicLayerInfos;

@end

