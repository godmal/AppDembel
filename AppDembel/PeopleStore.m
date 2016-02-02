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
    NSDictionary* encodedPeople = [[NSDictionary alloc] initWithContentsOfFile:_plistPath];
    return [self decodePeopleFromData:encodedPeople];
}

-(NSMutableDictionary*) encodePeopleToData:(NSMutableDictionary*) people {
    NSMutableDictionary* encodedPeople = [[NSMutableDictionary alloc] init];
    
    for (NSString* ID in people) {
        NSData* convertedValue = [NSKeyedArchiver archivedDataWithRootObject:[people valueForKey:ID]];
        [encodedPeople setObject:convertedValue forKey:ID];
    }
    return encodedPeople;
}

-(NSMutableDictionary*) decodePeopleFromData: (NSDictionary*) encodedPeople {
    NSMutableDictionary* decodedPeople = [[NSMutableDictionary alloc] init];
    
    for (NSString* ID in encodedPeople) {
        NSData* undecodedPerson = [encodedPeople valueForKey:ID];
        [decodedPeople setObject:[NSKeyedUnarchiver unarchiveObjectWithData:undecodedPerson] forKey:ID];
    }
    return decodedPeople;
}


-(void) removeAll {
    [[[NSDictionary alloc] init] writeToFile:_plistPath atomically:YES];
}

@end
