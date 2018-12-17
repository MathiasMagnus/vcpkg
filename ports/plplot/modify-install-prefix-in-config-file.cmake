diff --git a/share/plplot/export_plplot.cmake b/share/plplot/export_plplot.cmake
index 61e0255..51e1d3b 100644
--- a/share/plplot/export_plplot.cmake
+++ b/share/plplot/export_plplot.cmake
@@ -42,10 +42,10 @@ unset(_expectedTargets)
 
 
 # Compute the installation prefix relative to this file.
-get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
-get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
-get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
-get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
+get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../.." PATH)
+#get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
+#get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
+#get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
 if(_IMPORT_PREFIX STREQUAL "/")
   set(_IMPORT_PREFIX "")
 endif()
