//
//  MusicItem.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "BaseModel.h"

@interface MusicItem : BaseModel

@property (nonatomic, strong) NSNumber *musicId;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artworkUrl100;
@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *primaryGenreName;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) UIImage *artwork100;

@end
