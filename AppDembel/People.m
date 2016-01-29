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
        self.people = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) add:(Person*) person {
    [self.people setObject:person forKey:[self generateID]];
}

-(void) save {
    [self.store save: self.people];
}

-(NSString*) generateID {
    NSString* resultID = [[NSString alloc] init];
    
    if (self.people.count == 0) {
        resultID = [[NSNumber numberWithInt:0] stringValue];
    } else {
        NSArray* existedIDs = [self.people allKeys];
        NSNumber* maxID = [existedIDs valueForKeyPath:@"@max.self"];
        resultID = [[NSNumber numberWithInt:maxID.intValue + 1] stringValue];
    }
    return resultID;
}

@end
