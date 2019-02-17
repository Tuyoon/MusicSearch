//
//  MusicStorage.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "MusicStorage.h"
#import "Music.h"
#import "MusicItem.h"
#import <CoreData/CoreData.h>

@implementation MusicStorage 

- (NSArray *)itemsWithQuery:(NSString *)query {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Music"];
    if (query.length > 0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(artistName contains[cd] %@) or (trackName contains[cd] %@)", query, query];
        [request setPredicate:filterPredicate];
    }
    NSSortDescriptor *sortDescriptor = [self sortDescriptor];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return [self allItemsByFetchRequest:request];
}

- (void)translateFromItem:(NSObject *)item toEntity:(ManagedObject *)entity {
    MusicItem *fromItem = (MusicItem *)item;
    Music *toEntity = (Music *)entity;
    toEntity.musicId = fromItem.musicId;
    toEntity.artistName = fromItem.artistName;
    toEntity.artworkUrl100 = fromItem.artworkUrl100;
    toEntity.collectionName = fromItem.collectionName;
    toEntity.trackName = fromItem.trackName;
    toEntity.primaryGenreName = fromItem.primaryGenreName;
    toEntity.releaseDate = fromItem.releaseDate;
    toEntity.artwork100 = UIImageJPEGRepresentation(fromItem.artwork100, 1);
}

- (void)translateFromEntity:(ManagedObject *)entity toItem:(NSObject *)item {
    MusicItem *toItem = (MusicItem *)item;
    Music *fromEntity = (Music *)entity;
    toItem.musicId = fromEntity.musicId;
    toItem.artistName = fromEntity.artistName;
    toItem.artworkUrl100 = fromEntity.artworkUrl100;
    toItem.collectionName = fromEntity.collectionName;
    toItem.trackName = fromEntity.trackName;
    toItem.primaryGenreName = fromEntity.primaryGenreName;
    toItem.releaseDate = fromEntity.releaseDate;
    toItem.artwork100 = [UIImage imageWithData:fromEntity.artwork100];
}

- (NSObject *)newItem {
    return [[MusicItem alloc] init];
}

- (NSString *)entityClassName {
    return NSStringFromClass([Music class]);
}

- (NSSortDescriptor *)sortDescriptor {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"trackName" ascending:YES];
    return descriptor;
}

- (NSPredicate *)predicateForEntityForItem:(NSObject *)item {
    MusicItem *musicItem = (MusicItem *)item;
    return [NSPredicate predicateWithFormat:@"musicId = %@", musicItem.musicId];
}

@end
