#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  audioplayers_windows
  connectivity_plus
  dart_discord_rpc
  desktop_webview_window
  file_selector_windows
  flutter_inappwebview_windows
  flutter_js
  flutter_secure_storage_windows
  irondash_engine_context
  media_kit_libs_windows_video
  media_kit_video
  protocol_handler_windows
  screen_retriever_windows
  sentry_flutter
  super_native_extensions
  url_launcher_windows
  video_player_win
  window_manager
  window_to_front
  windows_taskbar
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  jni
  rhttp
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
