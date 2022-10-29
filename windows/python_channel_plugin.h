#ifndef FLUTTER_PLUGIN_PYTHON_CHANNEL_PLUGIN_H_
#define FLUTTER_PLUGIN_PYTHON_CHANNEL_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace python_channel {

class PythonChannelPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PythonChannelPlugin();

  virtual ~PythonChannelPlugin();

  // Disallow copy and assign.
  PythonChannelPlugin(const PythonChannelPlugin&) = delete;
  PythonChannelPlugin& operator=(const PythonChannelPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace python_channel

#endif  // FLUTTER_PLUGIN_PYTHON_CHANNEL_PLUGIN_H_
