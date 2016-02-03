//
//  PeopleStore.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "PeopleStore.h"


@implementation PeopleStore {
    NSString* _plistPath;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        _plistPath = [basePath stringByAppendingPathComponent:@"userDataPlist.plist"];
    }
    return self;
}

- (void) save: (NSMutableDictionary*) people {
    NSError *error = nil;
    NSData *representation = [NSPropertyListSerialization
        dataWithPropertyList:[self encodePeopleToData: people]
        format:NSPropertyListXMLFormat_v1_0
        options:0
        error:&error
    ];
    
    [representation writeToFile:_plistPath atomically:YES];
}

-(NSDictionary*) load {
    [self removeAll];
    NSDictionary* encodedPeople = [[NSDictionary alloc] initWithContentsOfFile:_plistPath];
    return [self decodePeopleFromData:encodedPeople];
}

-(NSMutableDictionary*) encodePeopleToData:(NSMutableDictionary*) people {
    NSMutableDictionary* encodedPeople = [[NSMutableDictionary alloc] init];
    
    for (NSNumber* ID in people) {
        NSString* stringID = [ID stringValue];
        NSData* convertedValue = [NSKeyedArchiver archivedDataWithRootObject:[people objectForKey:ID]];
        [encodedPeople setObject:convertedValue forKey:stringID];
        
    }
    return encodedPeople;
}

-(NSMutableDictionary*) decodePeopleFromData: (NSDictionary*) encodedPeople {
    NSMutableDictionary* decodedPeople = [[NSMutableDictionary alloc] init];
    
    for (NSString* ID in encodedPeople) {
        NSNumber* numberID = [[NSNumber alloc] initWithInt:[ID intValue]];
        NSData* undecodedPerson = [encodedPeople valueForKey:ID];
        [decodedPeople setObject:[NSKeyedUnarchiver unarchiveObjectWithData:undecodedPerson] forKey:numberID];
    }
    return decodedPeople;
}


-(void) removeAll {
    [@{} writeToFile:_plistPath atomically:YES];
}

@end
