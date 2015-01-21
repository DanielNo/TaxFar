//
//  DeviceHardware.h
//  TaxFar
//
//  Created by Daniel No on 12/1/14.
//  Copyright (c) 2014 Eminence Mobile Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHardware : NSObject {
    
}
+ (NSString *) platform;
+ (NSString *) platformType:(NSString *)platform;
+ (BOOL)iPhone4;
+ (BOOL)simulator;

@end