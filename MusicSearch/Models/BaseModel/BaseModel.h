//
//  BaseModel.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (instancetype)itemFromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)itemsFromDictionariesArray:(NSArray *)dictionariesArray;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
