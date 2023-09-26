#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include <memory>

#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

  int lastUsedFakePoint = 0;

  #define POINT_COUNT 15

// Livingston to Carter's down highway 89 (14 points)
double fakePoints[POINT_COUNT][2] {
  { 45.637212864,-110.575227850 },
  { 45.631318061,-110.576450476 }, // 662.207 m
  { 45.625158265,-110.577715959 }, // 691.842 m
  { 45.622090555,-110.578528077 }, // 346.847 m
  { 45.620081191,-110.578939675 }, // 225.671 m
  { 45.617728383,-110.579040817 }, // 261.689 m
  { 45.615780864,-110.578834501 }, // 217.107 m
  { 45.612472914,-110.577637996 }, // 379.350 m
  { 45.610107948,-110.576689601 }, // 273.075 m
  { 45.607499436,-110.575680065 }, // 300.442 m
  { 45.605574212,-110.574980773 }, // 220.839 m
  { 45.602835275,-110.573991781 }, // 314.067 m
  { 45.600199052,-110.572963170 }, // 303.807 m
  { 45.598274508,-110.572203981 }, // 221.961 m
  { -1, -1 }, // Ok, stop
};                      // total // 4,418.904 m

// A walk down the block (17 points)
  // double fakePoints[POINT_COUNT][2]{
  //       { 45.6530606,-110.5638456 },
  //       { 45.6531729, -110.5638227 },
  //       { 45.653217,-110.5638329 },
  //       { 45.653211,-110.5637774 },
  //       { 45.6532131,-110.5638283 },
  //       { 45.6532751,-110.563932 },
  //       { 45.6533471,-110.5639867 },
  //       { 45.6534493,-110.5639959 },
  //       { 45.6535751,-110.5640453 },
  //       { 45.653605,-110.5641045 },
  //       { 45.6536302,-110.5641211 },
  //       { 45.6537156,-110.5641574 },
  //       { 45.653841,-110.5641983 },
  //       { 45.6538758,-110.5642895 },
  //       { 45.6539424,-110.5646416 }, // > 100m, 13 skips
  //       { 45.6539565,-110.5647275 },
  //       { 45.6539567,-110.564763 }
  // };
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
