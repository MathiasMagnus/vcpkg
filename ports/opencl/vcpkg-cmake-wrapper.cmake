_find_package(${ARGS})
if(NOT BUILD_SHARED_LIBS AND (NOT CMAKE_SYSTEM_NAME MATCHES "Darwin"))
  set(OpenCL_Extra_Libs ${CMAKE_DL_LIBS})
  if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    list(APPEND OpenCL_Extra_Libs cfgmgr32)
  endif(CMAKE_SYSTEM_NAME MATCHES "Windows")
  if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    list(APPEND OpenCL_Extra_Libs pthread)
  endif(CMAKE_SYSTEM_NAME MATCHES "Linux")

  if(TARGET OpenCL::OpenCL)
      set_property(TARGET OpenCL::OpenCL APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${OpenCL_Extra_Libs})
  endif()
  if(OpenCL_LIBRARIES)
      list(APPEND OpenCL_LIBRARIES ${OpenCL_Extra_Libs})
  endif()
  if(OPENCL_LIBRARIES)
      list(APPEND OPENCL_LIBRARIES ${OpenCL_Extra_Libs})
      message(STATUS "OPENCL_LIBRARIES: ${OPENCL_LIBRARIES}")
  endif()
endif()