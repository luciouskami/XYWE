#ifndef WMBaseIncluded
#define WMBaseIncluded

library WMBase initializer init

#if WARCRAFT_VERSION >= 124
#  include "WM/Base/WMHT124.j"
#else
#  include "WM/Base/WMRB120.j"
#endif
#
#  include "WM/Base/WMGeneral.j"

endlibrary

#endif
