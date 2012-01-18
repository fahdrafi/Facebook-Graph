//
//  Node+SetterExtension.m
//  Facebook Graph
//
//  Created by Fahd on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Node+SetterExtension.h"

@implementation Node (Node_SetterExtension)

-(void)setValuesForDefinedKeysWithDictionary:(NSDictionary *)dict {
    NSArray* myKeys = [[[self entity] attributesByName] allKeys];
    for (NSString* key in myKeys) {
        if ([key isEqualToString:@"id"])
            continue;
        if (![[dict allKeys] containsObject:key])
            continue;

        // Handle cases here!!
        if ([key isEqualToString:@"from"]) {
            [self setValue:[dict valueForKeyPath:@"from.name"] forKey:key];
            [self setValue:[dict valueForKeyPath:@"from.id"] forKey:@"fromID"];
        } else if ([key isEqualToString:@"location"]) {
            if ([[dict valueForKeyPath:@"location.id"] length])
                [self setValue:[dict valueForKeyPath:@"location.name"] forKey:key];
        } else {
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
}

@end
