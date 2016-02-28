//
//  People.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 28.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class PeopleStore;

@interface People : NSObject

@property (strong, nonatomic) PeopleStore* store;
@property (strong, nonatomic) NSMutableArray* people;

-(instancetype)initWithStore:(PeopleStore*) store;
-(void) add:(Person*) person;
-(void) updatePersonBy:(NSUInteger) personID with:(Person*) updatedPerson;
-(void) removePerson:(NSUInteger) personID;
-(void) removeAll;
-(NSArray*) getAllNames;
-(NSArray*) getAllDatesStrings;

@end
