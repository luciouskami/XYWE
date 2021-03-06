﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYInfo
    {
        public static string YDVersion = "1.30.6";
        public static string Version = "1.1.Alpha.8 Patch.1"; // Used in version verify & launcher's version mark and update check
        public static string VersionClass = "内部预览版";

        public static string EditorName = "咸鱼地图编辑器";
        public static string EditorNameMin = "XY World Editor";

        public static string VersionName = "咸鱼降临";
        public static string VersionNameMin = "XYJL";

        public static Dictionary<string, string> CompilerDefaultVariables = new Dictionary<string, string>
        {
            [nameof(YDVersion)] = YDVersion,
            [nameof(Version)] = Version,
            [nameof(VersionClass)] = VersionClass,

            [nameof(EditorName)] = EditorName,
            [nameof(EditorNameMin)] = EditorNameMin,

            [nameof(VersionName)] = VersionName,
            [nameof(VersionNameMin)] = VersionNameMin,
        };
    }
}
