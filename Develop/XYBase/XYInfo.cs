using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase {
    public static class XYInfo {
        public const string YDVersion = "1.30.4";
        public const string Version = "1.1.Alpha.7"; // Used in version verify & launcher's version mark and update check
        public const string VersionClass = "内部预览版 & 预发布版";

        public const string EditorName = "咸鱼地图编辑器";
        public const string EditorNameMin = "XY World Editor";

        public const string VersionName = "咸鱼降临";
        public const string VersionNameMin = "XYJL";

        public static Dictionary<string, string> CompilerDefaultVariables = new Dictionary<string, string>
        {
            ["YDVersion"] = YDVersion,
            ["Version"] = Version,
            ["VersionClass"] = VersionClass,

            ["EditorName"] = EditorName,
            ["EditorNameMin"] = EditorNameMin,

            ["VersionName"] = VersionName,
            ["VersionNameMin"] = VersionNameMin,
        };
    }
}
