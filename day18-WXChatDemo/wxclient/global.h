#ifndef GLOBAL_H
#define GLOBAL_H
/******************************************************************************
 *
 * @file       global.h
 * @brief      全局变量存放该文件内
 *
 * @author     恋恋风辰
 * @date       2023/05/24
 * @history
 *****************************************************************************/
#include <QString>
extern QString g_app_path;
extern QString g_config_path;
extern QString g_webhost;
extern QString g_webport;
extern QString g_weburl_prefix;



enum ErrorCodes{
    Error_Json = 1001,  //Json解析错误
};

#endif // GLOBAL_H
