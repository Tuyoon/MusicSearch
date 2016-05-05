//
//  MusicStorage.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "Storage.h"

@interface MusicStorage : Storage

- (NSArray *)itemsWithTerm:(NSString *)term;

@end
