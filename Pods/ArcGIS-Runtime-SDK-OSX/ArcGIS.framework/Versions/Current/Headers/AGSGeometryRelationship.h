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

@class AGSGeometry;

/** @file AGSGeometryRelationship.h */ //Required for Globals API doc

/**  Object returned by <code>AGSGeometryServiceTask</code>'s 
 <code>relationWithParameters:</code> operation.
 
 The <code>relationWithParameters:</code> operation on  AGSGeometryServiceTask
 returns an array of <code>%AGSGeometryRelationship</code> objects. These
 objects demonstrate the relationship of @p geometry1 in relation to 
 @p geometry2 characterized by the given @p type.
 
 Possible values of @p type include members of the  AGSGeometryRelation
 enumeration.
 
 
 */
@interface AGSGeometryRelationship : NSObject

/** The geometry whose relation is being questioned.
 @since 10.2
 */
@property (nonatomic, strong, readonly) AGSGeometry *geometry1;

/** The geometry being used to relate to.
 @since 10.2
 */
@property (nonatomic, strong, readonly) AGSGeometry *geometry2;

/** Relationship between @p geometry1 and @p geometry2. Possible values include
 
 @li 		AGSGeometryRelationCross
 @li 		AGSGeometryRelationDisjoint
 @li 		AGSGeometryRelationIn
 @li 		AGSGeometryRelationInteriorIntersection
 @li 		AGSGeometryRelationIntersection
 @li 		AGSGeometryRelationLineCoincidence
 @li 		AGSGeometryRelationLineTouch
 @li 		AGSGeometryRelationOverlap
 @li 		AGSGeometryRelationPointTouch
 @li 		AGSGeometryRelationTouch
 @li 		AGSGeometryRelationWithin
 @li 		AGSGeometryRelationRelation		
 
 @since 10.2
 */
@property (nonatomic, assign, readonly) AGSGeometryRelation type;



@end
