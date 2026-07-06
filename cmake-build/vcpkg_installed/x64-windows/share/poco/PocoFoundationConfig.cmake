if(ON)
	include(CMakeFindDependencyMacro)
	list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
	find_dependency(ZLIB REQUIRED)
	find_dependency(PCRE2 REQUIRED)
	find_dependency(unofficial-utf8proc REQUIRED)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/PocoFoundationTargets.cmake")
