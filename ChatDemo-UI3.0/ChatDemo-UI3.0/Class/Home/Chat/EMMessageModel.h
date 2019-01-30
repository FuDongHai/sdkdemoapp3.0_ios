//
//  EMMessageModel.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/1/18.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMMessageModel : NSObject

@property (nonatomic, strong) EMMessage *emModel;

@property (nonatomic) EMMessageDirection direction;

@property (nonatomic) EMMessageBodyType type;

@property (nonatomic) BOOL isPlaying;

- (instancetype)initWithEMMessage:(EMMessage *)aMsg;

@end

NS_ASSUME_NONNULL_END
