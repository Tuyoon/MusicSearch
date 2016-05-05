//
//  History.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "ManagedObject.h"

@interface History : ManagedObject

@property (nullable, nonatomic, retain) NSNumber *historyId;
@property (nullable, nonatomic, retain) NSString *term;

@end
