//
//  ZZModelConfig.h
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZThirdPartLibType) {
    ZZThirdPartLibTypeNone,
    ZZThirdPartLibTypeMJExtension,
};

@interface ZZModelConfig : NSObject

@property (nonatomic, strong) NSString *authorName;

@property (nonatomic, assign) ZZThirdPartLibType thirdPartLibType;

@property (nonatomic, strong) NSString *classPrefix;

@property (nonatomic, strong) NSString *classSuffix;

@property (nonatomic, strong) NSArray *classIgnoreWords;

@property (nonatomic, assign) BOOL userOriginClassNamsAsPrefix;

+ (ZZModelConfig *)sharedInstance;

- (void)resetToDefaultConfig;

@end
