//
//  StatusDetailsController.h
//  Facebook Graph
//
//  Created by Fahd on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailsController.h"

@interface StatusDetailsController : DetailsController {
    UILabel *messageLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *messageLabel;

@end
