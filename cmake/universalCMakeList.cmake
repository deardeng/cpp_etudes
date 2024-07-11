######################################################
####文件universalCMakeList.cmake， 相当于C里的 XXX.h文件###
###当然了，你也可以直接加到CMakeLists.txt 的最顶部             ###
######################################################

#获取当前目录的子目录列表
macro(listSubDir curdir result)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            list(APPEND dirlist ${child})
        endif()
    endforeach()
    set(${result} ${dirlist})
endmacro()

#各目录下CMakeLists.txt内容，用于生成编译各模块的Makefile
macro(universalCMakeList)
    # 获取当前目录下的源文件名列表
    unset(SRC_FILE)
    aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SRC_FILE)

    #如果当前目录下有源文件
    list(LENGTH SRC_FILE SRC_LEN)
    if(${SRC_LEN})
        #自动设置目标名称(上级目录名称_当前目录名称)
        get_filename_component(UPPER_FOLDER_DIRECTOR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)
        get_filename_component(UPPER_FOLDER ${UPPER_FOLDER_DIRECTOR} NAME)
        get_filename_component(CURRENT_FOLDER ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        set(TARGET_NAME "${UPPER_FOLDER}_${CURRENT_FOLDER}")

        #保存目标名称
        set(TARGET_NAME_LIST ${TARGET_NAME_LIST} ${TARGET_NAME} CACHE STRING INTERNAL FORCE)

        #生成目标
        add_library(${TARGET_NAME} OBJECT ${SRC_FILE})

    endif()

    #自动轮询子目录
    listSubDir(${CMAKE_CURRENT_SOURCE_DIR} CHILD_DIR_LIST)
    foreach(dir ${CHILD_DIR_LIST})
        add_subdirectory(${dir})
    endforeach(dir)
endmacro()

#创建或者删除各目录下CMakeLists.txt
function(cmakeListsCtrl curdir isrmfile)
    if(NOT IS_DIRECTORY ${curdir})
        return()
    endif()

    #创建一个文件CMakeLists.txt,并写入指定内容
    if(isrmfile)
        file(REMOVE "${curdir}/CMakeLists.txt")
        message(STATUS "remove ${curdir}/CMakeLists.txt")
    else()
        file(WRITE "${curdir}/CMakeLists.txt" "universalCMakeList()")
        message(STATUS "write msg to ${curdir}/CMakeLists.txt")
    endif()

    #获取当前目录下的所有子目录列表
    set(filelist "")
    file(GLOB filelist RELATIVE ${curdir} ${curdir}/*)
    set(filename "")
    set(childdirlist "")
    foreach(filename ${filelist})
        if(IS_DIRECTORY ${curdir}/${filename})
            set(rmflag isrmfile)
            cmakeListsCtrl(${curdir}/${filename} ${isrmfile})
        endif()
    endforeach()
endfunction(cmakeListsCtrl)
