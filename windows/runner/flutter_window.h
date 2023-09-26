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

  #define POINT_COUNT 11

// A random line on Google Earth, down highway 89
//   double fakePoints[POINT_COUNT][2]{
//       { 45.626837, -110.5775534 },
//       { 45.6399944, -110.5747258 },
//   };

// A nice drive (11 points)
double fakePoints[POINT_COUNT][2] {
  {45.622762266,-110.578366064},
  {45.621571636,-110.578621539},
  {45.620524724,-110.578824198},
  {45.619219474,-110.579010140},
  {45.617965508,-110.579015332},
  {45.616869244,-110.578882614},
  {45.615293799,-110.578709212},
  {45.613674804,-110.578149992},
  {45.612033266,-110.577497189},
  {45.609136241,-110.576227786},
  {45.607474213,-110.575604775},
};

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
