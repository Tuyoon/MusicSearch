//
//  Storage.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ManagedObject;
@class NSFetchRequest;

@interface Storage : NSObject

+ (NSURL *)storagePath;
- (NSArray *)allItems;
- (NSArray *)allItemsByFetchRequest:(NSFetchRequest *)fetchRequest;
- (void)saveItems:(NSArray *)items;

#if NS_BLOCKS_AVAILABLE
- (void)performBlock:(void (^)())block;
- (void)performBlockAndWait:(void (^)())block;
#endif

- (void)translateFromItem:(NSObject *)item toEntity:(ManagedObject *)entity;
- (void)translateFromEntity:(ManagedObject *)entity toItem:(NSObject *)item;
- (NSObject *)newItem;
- (NSString *)entityClassName;
- (NSSortDescriptor *)sortDescriptor;
- (NSPredicate *)predicateForEntityForItem:(NSObject *)item;

@end
