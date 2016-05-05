//
//  BaseModel.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary {
    BaseModel *item = [[[self class] alloc] initWithDictionary:dictionary];
    
    return item;
}

+ (NSArray *)itemsFromDictionariesArray:(NSArray *)dictionariesArray {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionariesArray) {
        BaseModel *item = [self itemFromDictionary:dictionary];
        [items addObject:item];
    }
    
    return [NSArray arrayWithArray:items];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        
    }
    
    return self;
}

@end
