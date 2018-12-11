//
//  MRCLConfig.h
//  MVVMReactiveCocoaLearn
//
//  Created by 杨世浩 on 2018/11/8.
//  Copyright © 2018 hao. All rights reserved.
//

#ifndef MRCLConfig_h
#define MRCLConfig_h

///------------
/// AppDelegate
///------------

#define MRCLSharedAppDelegate ((MRCLAppDelegate *)[UIApplication sharedApplication].delegate)
#define MRCLSharedAppClient ((MRCLAppDelegate *)[UIApplication sharedApplication].delegate).client

///------------
/// Client Info
///------------

#define MRC_CLIENT_ID     @"710bab8359c280f2f8e6"
#define MRC_CLIENT_SECRET @"8db7009b94d0e2b30d24689c4b5f71591b8b7922"

///-----------
/// SSKeychain
///-----------

#define MRCL_SERVICE_NAME @"com.hao.MVVMReactiveCocoaLearn"
#define MRCL_ACCESS_TOKEN @"AccessToken"
#define MRCL_RAW_LOGIN    @"RawLogin"
#define MRCL_PASSWORD     @"Password"

///----------------------
/// Persistence Directory
///----------------------

#define MRCL_DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* MRCLConfig_h */
