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

/** @file AGSGeneralizeParameters.h */ //Required for Globals API doc

/**  Parameters for <code>AGSGeometryServiceTask</code>'s 
 <code>generalizeWithParameters:</code> operation.
 
 Instances of this class represent parameters for <code>AGSGeometryServiceTask</code>'s 
 <code>generalizewithParameters:</code> operation. 
 
 
 @see AGSGeometryServiceTask
 */
@interface AGSGeneralizeParameters : NSObject <AGSCoding>

/** Specifies the maximum deviation for constructing a generalized geometry 
 based on the input geometries.
 @since 10.2
 */
@property (nonatomic) double maxDeviation;

/** (Optional) The units to be used for maxDeviation. If the @p deviationUnit 
 is not specified, the units are derived from the spatial reference of the input 
 geometries. 
 @since 10.2
 */
@property (nonatomic) AGSSRUnit deviationUnit;

/** The array of input geometries to generalize. All geometries in this array 
 must be of the same geometry type ( AGSPolyline or  AGSPolygon).
 @since 10.2
 */
@property (nonatomic, copy) NSArray *geometries;

/** Returns an autoreleased instance of the <code>%AGSGeneralizeParameters</code> object.
 @since 10.2
 */
+ (id)generalizeParameters;

@end