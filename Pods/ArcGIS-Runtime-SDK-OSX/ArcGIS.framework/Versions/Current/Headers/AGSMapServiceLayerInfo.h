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

@class AGSLayerInfo;
@protocol AGSCoding;

/** @file AGSMapServiceLayerInfo.h */ //Required for Globals API doc

#pragma mark -

/**  Information about a layer in an ArcGIS Server service.
 
 Instances of this class represent information about a layer in an ArcGIS Server 
 map or feature service.

 
 */
@interface AGSMapServiceLayerInfo : AGSLayerInfo <AGSCoding>

/** Default visibility of the layer, as defined by the service.
 @since 10.2
 */
@property (nonatomic, readonly) BOOL defaultVisibility;

/** ID of the parent layer if this layer is part of a group layer. Otherwise, 
 the value is -1. 
 @since 10.2
 */
@property (nonatomic, readonly) NSInteger parentLayerID;

/** An array of IDs of descendant layers if this layer is a parent layer. 
 Otherwise, the value is <code>nil</code>. 
 @since 10.2
 */
@property (nonatomic, copy, readonly) NSArray *subLayerIDs;

@end
