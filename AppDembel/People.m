//
//  People.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 28.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "People.h"
#import "PeopleStore.h"
#import "Person.h"
#import "Underscore.h"
#import "DateUtils.h"

#define _ Underscore

@implementation People {

}

- (instancetype)initWithStore:(PeopleStore*) store {
    self = [super init];
    if (self) {
        self.store = store;
        self.people = [[NSMutableArray alloc] initWithArray:[self.store load]];
    }
    return self;
}

-(void) add:(Person*) person {
    if ([DateUtils isValid:person.date]) {
        [self.people addObject:person];
        [self saveAndNotify];
    }
}

-(void) removeAll {
    self.people = [[NSMutableArray alloc] init];
    [self saveAndNotify];
}

-(void) removePerson:(NSUInteger) personID {
    [self.people removeObjectAtIndex:personID];
    [self saveAndNotify];
}

-(void) updatePersonBy:(NSUInteger) personID with:(Person*) updatedPerson {
    if ([DateUtils isValid:updatedPerson.date]) {
        [self.people replaceObjectAtIndex:personID withObject:updatedPerson];
        [self saveAndNotify];
    }
}

-(void) saveToStore {
    [self.store save:self.people];
}

-(void) notify {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appStateChanged" object:nil];
}

-(void) saveAndNotify {
    [self saveToStore];
    [self notify];
}

-(NSArray*) getAllNames {
    return _.arrayMap(self.people, ^(Person* person) {
        return person.name;
    });
}

-(NSArray*) getAllDatesStrings {
    return _.arrayMap(self.people, ^(Person* person) {
        return [DateUtils convertDateToString:person.date];
    });
}

@end
