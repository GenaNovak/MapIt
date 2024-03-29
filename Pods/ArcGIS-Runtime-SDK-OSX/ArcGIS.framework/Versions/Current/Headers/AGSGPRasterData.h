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



/** @file AGSGPRasterData.h */ //Required for Globals API doc

/**  A data object containing a raster data source.
 
 Instances of this class represent a raster data source.
 
  
 */
@interface AGSGPRasterData : NSObject <AGSCoding>

/** URL to the location of the raster data file.
 @since 10.2
 */
@property (nonatomic, copy) NSURL *URL;

/** Specifies the format of the raster data such as "jpg", "tif" etc.
 @since 10.2
 */
@property (nonatomic, copy) NSString *format;

@end