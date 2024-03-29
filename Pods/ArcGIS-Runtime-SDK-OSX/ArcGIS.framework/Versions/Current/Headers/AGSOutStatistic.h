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

#import <Foundation/Foundation.h>

/**  Parameters for a statistic calculation.
 
 Instances of this class represent a definition for a statistic calculation. The parameters are used to execute a statistical calculation in a query.
 @since 10.2
 @see AGSQuery
 */
@interface AGSOutStatistic : NSObject <AGSCoding>

/** The statistical operation that will be calculated in the query.
 Possible values include
 
 @li  AGSQueryStatisticsTypeCount
 @li  AGSQueryStatisticsTypeSum
 @li  AGSQueryStatisticsTypeMin
 @li  AGSQueryStatisticsTypeMax
 @li  AGSQueryStatisticsTypeAvg
 @li  AGSQueryStatisticsTypeStddev
 @li  AGSQueryStatisticsTypeVar
 
 @since 10.2
 */
@property (nonatomic, assign) AGSQueryStatisticsType statisticType;

/**
 The field on which the statistical calculation will be done.
 
 @since 10.2
 */
@property (nonatomic, copy) NSString *onStatisticField;

/**
The name of the output field containing the result of the calculation.Valid field 
 names can only contain alpha-numeric characters and an underscore.
 
 @since 10.2
 */
@property (nonatomic, copy) NSString *outStatisticFieldName;

@end
