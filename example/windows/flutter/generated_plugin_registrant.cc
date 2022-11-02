//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_window_close/flutter_window_close_plugin.h>
#include <python_channel/python_channel_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterWindowClosePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWindowClosePlugin"));
  PythonChannelPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PythonChannelPluginCApi"));
}
