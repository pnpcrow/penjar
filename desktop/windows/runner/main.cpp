#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <cstring>
#include <optional>
#include <string>
#include <vector>

#include "flutter_window.h"
#include "utils.h"

namespace {
constexpr const wchar_t kPenjarWindowTitle[] = L"Penjar Desktop";
constexpr ULONG_PTR kDesktopLaunchRouteCopyDataId = 0x504A524C;

std::optional<std::string> ExtractLaunchRoute(
    const std::vector<std::string>& args) {
  for (const std::string& argument : args) {
    if (argument.rfind("--penjar-route=", 0) == 0) {
      const std::string route = argument.substr(strlen("--penjar-route="));
      if (!route.empty()) {
        return route;
      }
      continue;
    }
    if (argument.rfind("--penjar-section=", 0) == 0) {
      const std::string section = argument.substr(strlen("--penjar-section="));
      if (!section.empty()) {
        return "penjar://section/" + section;
      }
      continue;
    }
    if (argument.rfind("penjar://", 0) == 0) {
      return argument;
    }
  }
  return std::nullopt;
}

bool RelayLaunchRouteToRunningWindow(const std::string& launch_route) {
  HWND existing_window = FindWindow(nullptr, kPenjarWindowTitle);
  if (existing_window == nullptr) {
    return false;
  }

  COPYDATASTRUCT payload{};
  payload.dwData = kDesktopLaunchRouteCopyDataId;
  payload.cbData = static_cast<DWORD>(launch_route.size() + 1);
  payload.lpData = const_cast<char*>(launch_route.c_str());
  SendMessage(existing_window, WM_COPYDATA, 0, reinterpret_cast<LPARAM>(&payload));
  ShowWindow(existing_window, SW_RESTORE);
  SetForegroundWindow(existing_window);
  return true;
}
}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();
  const std::optional<std::string> launch_route =
      ExtractLaunchRoute(command_line_arguments);
  if (launch_route.has_value() &&
      RelayLaunchRouteToRunningWindow(launch_route.value())) {
    ::CoUninitialize();
    return EXIT_SUCCESS;
  }

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"Penjar Desktop", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
