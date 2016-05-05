//
//  HistoryItem.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "BaseModel.h"

@interface HistoryItem : BaseModel

@property (nonatomic, assign) NSTimeInterval historyId;
@property (nonatomic, strong) NSString *term;
- (instancetype)initWithTerm:(NSString *)term;

@end
