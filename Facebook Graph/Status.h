//
//  Status.h
//  Facebook Graph
//
//  Created by Fahd on 10/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Post.h"

@class Comment;

@interface Status : Post {
@private
}
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * story;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Status (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
