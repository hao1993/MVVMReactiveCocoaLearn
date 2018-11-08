//
//  MRCTConstant.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#ifndef MRCTConstant_h
#define MRCTConstant_h

///------
/// NSLog
///------

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define MRCLogError(error) NSLog(@"Error: %@", error)

///------
/// Block
///------

typedef void (^VoidBlock)();

#endif /* MRCTConstant_h */
