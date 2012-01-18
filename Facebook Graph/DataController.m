//
//  DataController.m
//  Facebook Graph
//
//  Created by Fahd on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "FBResponseHandler.h"

@implementation DataController

@synthesize moc, facebook;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNode:) name:@"NotificationNodeNeedsUpdate" object:nil];
    }
    
    return self;
}

-(void)updateLinksForNode:(Node*)targetNode ofType:(NSString*)linksType {
    
    if ([targetNode.linksAvailable integerValue]>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationLinksUpdated" object:targetNode userInfo:[NSDictionary dictionaryWithObject:linksType forKey:@"type"]];
    } else {
        
        FBResponseHandler* responseHandler = [[FBResponseHandler alloc] init];
        responseHandler.requestType = [NSString stringWithString:@"Links"];
        responseHandler.targetNode = targetNode;
        responseHandler.dataController = self;
        responseHandler.linksType = linksType;
        
        NSMutableDictionary* fieldsDict = [NSMutableDictionary dictionary];
        [fieldsDict setValue:@"id,type" forKey:@"home"];
        [fieldsDict setValue:@"id,type" forKey:@"feed"];
        [fieldsDict setValue:@"id" forKey:@"likes"];
        [fieldsDict setValue:@"id" forKey:@"comments"];
        
        [self.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/%@?fields=%@",targetNode.id, linksType, [fieldsDict valueForKey:linksType]]
                                andDelegate:responseHandler];
    }
}

-(NSArray*)linkTypesForNode:(Node *)queryNode {
    NSMutableArray* linkTypes = [[[[[queryNode entity] relationshipsByName] allKeys] mutableCopy] autorelease];
    if (![queryNode.id isEqualToString:@"me"]) {
        [linkTypes removeObject:@"home"];
    } else {
        [linkTypes removeObject:@"feed"];
    }
    return [NSArray arrayWithArray:linkTypes];
}

-(void)updateNode:(NSNotification*) notif {
    Node* node = [notif object];
    NSTimeInterval timeSinceLastRequest = [node.updatedTime timeIntervalSinceNow];
    if (abs(timeSinceLastRequest)>5.0) {
        
        NSEntityDescription* entity = [node entity];
        NSString* nodeType = [entity name];
        FBResponseHandler* newResponseHandler = [[FBResponseHandler alloc] init];
        newResponseHandler.requestType = @"Node";
        newResponseHandler.targetNode = node;
        newResponseHandler.nodeType = nodeType;
        newResponseHandler.dataController = self;
        
        node.updatedTime = [NSDate date];
        [self.facebook requestWithGraphPath:node.id /*andParams:params*/ andDelegate:newResponseHandler];        
    }
        
        
//    NSArray* attributes = [entity.attributesByName allKeys];
//    NSString* charsToRemove = [NSString stringWithString:@" ()\"\n"];
//    NSMutableString* fields = [[attributes.description mutableCopy] autorelease];
//    for (NSInteger i=0; i<[charsToRemove length]; i++) {
//        NSString* charToRemove = [charsToRemove substringWithRange:NSMakeRange(i, 1)];
//        fields = [[[fields stringByReplacingOccurrencesOfString:charToRemove withString:@""] mutableCopy] autorelease];
//    }
//    fields = [[[fields stringByReplacingOccurrencesOfString:@"version," withString:@""] mutableCopy] autorelease];
//    fields = [[[fields stringByReplacingOccurrencesOfString:@"linksAvailable," withString:@""] mutableCopy] autorelease];
//    fields = [[[fields stringByReplacingOccurrencesOfString:@"fromID," withString:@""] mutableCopy] autorelease];
//    fields = [[[fields stringByReplacingOccurrencesOfString:@"thumbnail," withString:@""] mutableCopy] autorelease];
//    fields = [[[fields stringByReplacingOccurrencesOfString:@"type," withString:@""] mutableCopy] autorelease];
//    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:fields forKey:@"fields"];
//    
//    if ([nodeType isEqualToString:@"Photo"]) {
//        [self.facebook requestWithGraphPath:node.id andParams:params andDelegate:newResponseHandler];        
//
//    } else {
//    [self.facebook requestWithGraphPath:node.id /*andParams:params*/ andDelegate:newResponseHandler];        
//    }
    
}

-(Node*)newNodeWithId:(NSString *)nodeId type:(NSString *)nodeType {
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:[nodeType capitalizedString] inManagedObjectContext:self.moc];
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %@", nodeId];
    [request setPredicate:predicate];
    NSError* error = nil;
    
    NSArray* results = [self.moc executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error.description);
        abort();
    }
    
    Node* newNode;
    
    if ([results count]) { // if Already present
        newNode = [results objectAtIndex:0];
    } else { // else create new
        newNode = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:self.moc];
        newNode.id = nodeId;
        newNode.version = [NSNumber numberWithInt:0];
        newNode.linksAvailable = [NSNumber numberWithInteger:0];
    }
    
    [newNode retain];
        
    return newNode;
}

@end
