//
//  Post.h
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Node.h"

@class User;

@interface Post : Node {
@private
}
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSSet *likes;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addLikesObject:(User *)value;
- (void)removeLikesObject:(User *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
