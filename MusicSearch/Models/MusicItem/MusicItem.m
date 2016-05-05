//
//  MusicItem.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "MusicItem.h"

@implementation MusicItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        _musicId = dictionary[@"trackId"];
        _artistName = dictionary[@"artistName"];
        _artworkUrl100 = dictionary[@"artworkUrl100"];
        _collectionName = dictionary[@"collectionName"];
        _trackName = dictionary[@"trackName"];
        _primaryGenreName = dictionary[@"primaryGenreName"];
        _releaseDate = dictionary[@"releaseDate"];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_artworkUrl100]];
        _artwork100 = [UIImage imageWithData:imageData];
    }
    
    return self;
}

@end
