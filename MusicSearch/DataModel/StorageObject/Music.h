//
//  Music.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "ManagedObject.h"

@interface Music : ManagedObject

@property (nullable, nonatomic, retain) NSNumber *musicId;
@property (nullable, nonatomic, retain) NSString *artistName;
@property (nullable, nonatomic, retain) NSString *artworkUrl100;
@property (nullable, nonatomic, retain) NSString *collectionName;
@property (nullable, nonatomic, retain) NSString *trackName;
@property (nullable, nonatomic, retain) NSString *primaryGenreName;
@property (nullable, nonatomic, retain) NSString *releaseDate;
@property (nullable, nonatomic, retain) NSData *artwork100;

@end
