#include "include/python_channel/python_channel_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "python_channel_plugin.h"

void PythonChannelPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  python_channel::PythonChannelPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
