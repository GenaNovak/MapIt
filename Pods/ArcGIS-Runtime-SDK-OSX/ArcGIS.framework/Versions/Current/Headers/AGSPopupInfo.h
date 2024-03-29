/*
 COPYRIGHT 2011 ESRI
 
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

@class AGSGraphic;
@class AGSFeatureLayer;
@class AGSGDBFeatureTable;

/** @file AGSPopupInfo.h */ //Required for Globals API doc

/**  A popup definition
 
 Instances of this class respresent popup definitions for features that need to be displayed in popups. Popup definitions contain information such as -
 
 @li Whether a user should be allowed to edit or delete the feature
 @li Which attributes of the feature should the popup display, whether they are editable, how to format numbers and dates, etc
 @li Whether the popup should show attachments for the feature
 @li What media, such as charts and images, should be displayed for the feature
 
 @since 10.2
 */
@interface AGSPopupInfo : NSObject <AGSCoding, NSCopying>

/** The title that is displayed for the graphic in the popup.
 This can contain a literal value, or a placeholder for value from the graphic's attribute. The placeholder needs to be of the form {field_name}
 where <i>field_name</i> is a key in the graphic's attributes.
 @since 10.2
 */
@property (nonatomic, copy) NSString *title;

/** The description that is shown for the graphic in the popup. This can be html. If description is nil then the fieldInfos are used 
 when viewing attributes.
 This can contain a literal value, or a placeholder for value from the graphic's attribute. The placeholder needs to be of the form {field_name}
 where <i>field_name</i> is a key in the graphic's attributes.
 @since 10.2
 */
@property (nonatomic, copy) NSString *customDescription;

/** The graphic's fields (as an array of  AGSPopupFieldInfo objects) that are to be displayed in the popup.
 If description is not nil then the fieldInfos are not used 
 when viewing attributes. 
 @since 10.2
 */
@property (nonatomic, copy) NSArray *fieldInfos;

/** The media (as an array of  AGSPopupMediaInfo objects) that is to be displayed in the popup.
 @since 10.2
 */
@property (nonatomic, copy) NSArray *mediaInfos;

/** Whether or not the popup should show attachments of the graphic.
 @since 10.2
 */
@property (nonatomic, assign) BOOL showAttachments;

/** Returns an autoreleased default AGSPopupInfo for a given graphic. 
 @param graphic If the graphic belongs to a feature layer, the constructor will consult the metadata on the feature layer and create a popup definition with appropriate defaults for  fieldInfos. Otherwise, it will inspect the attributes of the graphic to create a basic popup definition which you can then programmatically modify.
 @return An autoreleased AGSPopupInfo
 @since 10.2
 */
+(AGSPopupInfo *)popupInfoForGraphic:(AGSGraphic *)graphic;

/** Creates a default AGSPopupInfo based on properties of an AGSFeatureLayer.
 @since 10.2
 */
+(AGSPopupInfo*)popupInfoForFeatureLayer:(AGSFeatureLayer*)featureLayer;

/** Creates a default AGSPopupInfo on the information from the feature.
 @since 10.2
 */
+(AGSPopupInfo*)popupInfoForGDBFeatureTable:(AGSGDBFeatureTable*)gdbFeatureTable;

@end

