//
//  PeopleStore.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleStore : NSObject

-(void) save:(NSMutableArray*) people;
-(NSArray*) load;

@end
