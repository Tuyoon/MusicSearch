//
//  MusicItem.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MusicItem : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *trackId;
@property (nonatomic, strong) NSString<Optional> *artistName;
@property (nonatomic, strong) NSString<Optional> *artworkUrl100;
@property (nonatomic, strong) NSString<Optional> *collectionName;
@property (nonatomic, strong) NSString<Optional> *trackName;
@property (nonatomic, strong) NSString<Optional> *primaryGenreName;
@property (nonatomic, strong) NSString<Optional> *releaseDate;

@end
