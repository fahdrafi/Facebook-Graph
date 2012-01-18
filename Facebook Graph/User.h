//
//  User.h
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Node.h"

@class Post;

@interface User : Node {
@private
}
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * middle_name;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * relationship_status;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *feed;
@property (nonatomic, retain) NSSet *home;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFeedObject:(Post *)value;
- (void)removeFeedObject:(Post *)value;
- (void)addFeed:(NSSet *)values;
- (void)removeFeed:(NSSet *)values;

- (void)addHomeObject:(Post *)value;
- (void)removeHomeObject:(Post *)value;
- (void)addHome:(NSSet *)values;
- (void)removeHome:(NSSet *)values;

@end
