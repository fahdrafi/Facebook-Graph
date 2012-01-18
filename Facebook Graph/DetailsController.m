//
//  DetailsController.m
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailsController.h"

@implementation DetailsController

@synthesize nodeData;

-(void) updateDetails:(DataController*)dataCon {
    [self updateView];
}

-(void) updateView {
    [self.view setNeedsDisplay];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)viewDidUnload {
    [self.nodeData removeObserver:self forKeyPath:@"version"];
    [super viewDidUnload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"version"]) {
        [self updateView];
    }
}

- (void)setNodeData:(Node *) newNode {
    if (nodeData) {
        [nodeData removeObserver:self forKeyPath:@"version"];
        [nodeData release];
    }
    
    nodeData = newNode;
    [nodeData retain];
    [nodeData addObserver:self forKeyPath:@"version" options:0 context:NULL];
    
    [self updateView];
}

- (void)dealloc {
    [nodeData release];
    [super dealloc];
}

@end
