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

@class AGSMPSymbolDictionaryFilter;

/** @file AGSMPSymbolDictionaryQuery.h */ //Required for Globals API doc

/**  A symbol dictionary query object.
 
 The  AGSMPSymbolDictionaryQuery class is used to query the symbol dictionary
 for a list of symbols. You can query symbols by filtering
 the dictionary with  AGSMPSymbolDictionaryFilters and/or keywords.
 
 
 */
@interface AGSMPSymbolDictionaryQuery : NSObject

/** The set of  AGSymbolDictionaryFilter objects for the query.
 @since 10.2
 */
@property (nonatomic, copy, readonly) NSSet* filters;

/** The set of keywords for the query.
 @since 10.2
 */
@property (nonatomic, copy, readonly) NSSet* keywords;

/** Adds a filter to the query.
 @param filter The symbol dictionary filter to add.
 @since 10.2
 */
- (void)addFilter:(AGSMPSymbolDictionaryFilter*)filter;

/** Adds a keyword to the query.
 @param keyword The keyword to add.
 @since 10.2
 */
- (void)addKeyword:(NSString*)keyword;

/** Removes all filters and keywords from the query.
 @since 10.2
 */
- (void)removeAll;

/** Removes the specified filter from the query.
 @param filter The filter to remove.
 @since 10.2
 */
- (void)removeFilter:(AGSMPSymbolDictionaryFilter*)filter;

/** Removes the specified keyword from the query.
 @param keyword The keyword to remove.
 @since 10.2
 */
- (void)removeKeyword:(NSString*)keyword;

@end
