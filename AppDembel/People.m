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
    [self.people addObject:person];
    [self saveToStore];
    [self notify];
}

-(void) removeAll {
    self.people = [[NSMutableArray alloc] init];
    [self saveToStore];
    [self notify];
}


-(void) removePerson:(NSUInteger) personID {
    [self.people removeObjectAtIndex:personID];
    [self saveToStore];
    [self notify];
}

-(void) saveToStore {
    [self.store save:self.people];
}

-(void) notify {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appStateChanged" object:nil];
}

@end
