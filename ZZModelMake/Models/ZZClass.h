//
//  ZZClass.h
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/16.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZProperty.h"

@interface ZZClass : NSObject

@property (nonatomic, strong, readonly) NSString *className;

@property (nonatomic, strong, readonly) NSArray *properties;

@property (nonatomic, strong, readonly) NSString *interfaceCode;

@property (nonatomic, strong, readonly) NSString *implementationCode;

- (id)initWithClassName:(NSString *)className andJson:(NSDictionary *)json;

- (BOOL)createFilesAtPath:(NSString *)path;

@end
