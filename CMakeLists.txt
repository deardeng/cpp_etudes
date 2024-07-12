cmake_minimum_required(VERSION 3.10)
project(boostasio-learn)
add_subdirectory(concurrent/day01-thread)
add_subdirectory(concurrent/day02-mutexlock/day02-mutexlock)
add_subdirectory(concurrent/day03-uniquelock/unique_lock)
add_subdirectory(concurrent/day04-singleton/Singleton)
add_subdirectory(concurrent/day05-conditionvariable/ConditionVariable/ConditionVariable)
add_subdirectory(concurrent/day06-future_and_promise/FutureAndPromise/FutureAndPromise)
add_subdirectory(concurrent/day07-async_function/async_function/async_function)
add_subdirectory(concurrent/day09-QASummary)
add_subdirectory(concurrent/day10-MemoryModel)
add_subdirectory(concurrent/day11-AcquireRelease/day11-AcquireRelease)
add_subdirectory(concurrent/day12-circularque/day12-circularque)
add_subdirectory(concurrent/day13-fence/day13-fence)
add_subdirectory(concurrent/day14-ThreadSafeContainer/day14-ThreadSafeContainer)
add_subdirectory(concurrent/day15-threadsafehash)
add_subdirectory(concurrent/day16-threadsafelist/day16-threadsafelist)
add_subdirectory(concurrent/day17-LockFreeStack)
add_subdirectory(concurrent/day18-LockFreeQue/day18-LockFreeQue)
add_subdirectory(concurrent/day19-parallensort)
add_subdirectory(concurrent/day20-Actor/day20-Actor)
add_subdirectory(concurrent/day21-ParallenAlgorithm/day21-ParallenAlgorithm)
add_subdirectory(concurrent/day22-ThreadPool/day22-ThreadPool)
add_subdirectory(concurrent/day23-interupthread/day23-interupthread)

#cmake_minimum_required(VERSION 3.20.1)
#
#project(universalCMakeList)
#
#include(cmake/universalCMakeList.cmake)
#
##################################################
##根据变量CMD值，来删除或者更新各目录下的CMakeLists.txt#
##使用方式 cmake .. -DCMD=remove
##使用方式 cmake .. -DCMD=update
##使用方式 cmake ..
##################################################
#if(DEFINED CMD)
#    if(${CMD} STREQUAL "remove")
#        message("remove:${CMD}")
#        cmakeListsCtrl(${PROJECT_SOURCE_DIR}/main ON)
#        cmakeListsCtrl(${PROJECT_SOURCE_DIR}/src ON)
#        return()
#    elseif(${CMD} STREQUAL "update")
#        message("update:${CMD}")
#        cmakeListsCtrl(${PROJECT_SOURCE_DIR}/main OFF)
#        cmakeListsCtrl(${PROJECT_SOURCE_DIR}/src OFF)
#    endif()
#endif()
##################################################
#
##编译器相关设置
#set(CMAKE_BUILD_TYPE DEBUGE)
#SET(CMAKE_C_COMPILER "gcc")
#SET(CMAKE_CXX_FLAGES "${CAMKE_CXX_FLAGES} -g")
#SET(CMAKE_CXX_COMPILER "g++")
#SET(CMAKE_CXX_FLAGES "${CAMKE_CXX_FLAGES} -g -std=c++11")
#
##设置生成的库的输出目录
#set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
#
##设置可执行文件的输出路径
#set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#
##添加头文件路径
#include_directories(${PROJECT_SOURCE_DIR}/include)
#include_directories(${PROJECT_SOURCE_DIR}/main)
#include_directories(${PROJECT_SOURCE_DIR}/src)
#
##添加引用的库路径
#link_directories(${PROJECT_SOURCE_DIR}/lib)
#
##设置全局变量，用来保存所有需要链接的目标名称
#unset(TARGET_NAME_LIST CACHE)
#set(TARGET_NAME_LIST "" CACHE STRING INTERNAL)
#
##依次添加需要编译的各个子目录
#add_subdirectory(src)
#add_subdirectory(main)
#add_subdirectory(concurrent)
#
##去除重复名称
#list(REMOVE_DUPLICATES TARGET_NAME_LIST)
#message("${TARGET_NAME_LIST}")
#
##生成可行性目标
#add_executable(${PROJECT_NAME})
#
##链接所有目标
#target_link_libraries(${PROJECT_NAME} ${TARGET_NAME_LIST})
