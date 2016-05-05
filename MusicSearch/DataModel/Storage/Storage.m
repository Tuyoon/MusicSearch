//
//  Storage.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "Storage.h"
#import <CoreData/CoreData.h>
#import "ManagedObject.h"

@implementation Storage {
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

+ (NSURL *)storagePath {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths firstObject];
    NSString *dataBasePath = [cachePath stringByAppendingPathComponent:@"Storage"];
    
    return [NSURL fileURLWithPath:dataBasePath isDirectory:NO];
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [[self class] storagePath];
    DLog(@"STORE URL: %@",storeUrl);
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:storeUrl error:nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            DLog(@"Error %@", [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSArray *)allItems {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityClassName]];
    
    return [self allItemsByFetchRequest:request];
}

- (NSArray *)allItemsByFetchRequest:(NSFetchRequest *)fetchRequest {
    NSMutableArray *result = [NSMutableArray array];
    
    [self performBlockAndWait:^{
        NSError *error = nil;
        NSArray *entities = [self executeFetchRequest:fetchRequest error:&error];
        
        if (error != nil) {
            return;
        }
        
        for (ManagedObject *entity in entities) {
            NSObject *newItem = [self newItem];
            [self translateFromEntity:entity toItem:newItem];
            [result addObject:newItem];
        }
    }];
    
    return result;
}

- (void)saveItems:(NSArray *)items {
    [self performBlockAndWait:^{
        for (NSObject *item in items){
            NSPredicate *predicate = [self predicateForEntityForItem:item];
            ManagedObject *entityToUpdate = [self entityWithPredicate:predicate];
            if (entityToUpdate == nil) {
                entityToUpdate = [self insertObjectWithEntityName:[self entityClassName]];
            }
            
            [self translateFromItem:item toEntity:entityToUpdate];
        }
        [self saveStorageChanges];
    }];
}

- (NSArray*)executeFetchRequest:(NSFetchRequest*)request error:(NSError**)error {
    return [[self managedObjectContext] executeFetchRequest:request error:error];
}

- (ManagedObject *)entityWithPredicate:(NSPredicate *)predicateForEntity {
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityClassName]];
    [request setPredicate:predicateForEntity];
    [request setFetchLimit:1];
    
    NSArray *objects = [self executeFetchRequest:request error:&error];
    
    if (error != nil) {
        return nil;
    }
    
    return ([objects count] > 0) ? [objects firstObject] : nil;
}

- (ManagedObject *)insertObjectWithEntityName:(NSString *)entityName {
    NSEntityDescription *entity = [[_managedObjectModel entitiesByName] valueForKey:entityName];
    if (entity == nil) {
        return nil;
    }
    ManagedObject *object = [[ManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:_managedObjectContext];
    
    return object;
}

- (void)saveStorageChanges {
    NSError *error = nil;
    [[self managedObjectContext] save:&error];
}

#if NS_BLOCKS_AVAILABLE

- (void)performBlock:(void (^)())block {
    [[self managedObjectContext] performBlock:block];
}

- (void)performBlockAndWait:(void (^)())block {
    [[self managedObjectContext] performBlockAndWait:block];
}

#endif

- (void)translateFromItem:(NSObject *)item toEntity:(ManagedObject *)entity {
    AssertOverride;
}

- (void)translateFromEntity:(ManagedObject *)entity toItem:(NSObject *)item {
    AssertOverride;
}

- (NSObject *)newItem {
    return [[NSObject alloc] init];
}

- (NSString *)entityClassName {
    AssertOverrideReturnNil;
}

- (NSPredicate *)predicateForEntityForItem:(NSObject *)item {
    AssertOverrideReturnNil;
}

@end
