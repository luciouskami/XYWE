using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace XYBase
{
    public static class XYPackage
    {
        public static List<string> GetExistPackage()
        {
            var list = new List<string>();
            var dirInfo = new DirectoryInfo(XYPath.Dir.SourcePackage);
            var dirs = dirInfo.EnumerateDirectories();
            foreach (var dir in dirs)
            {
                list.Add(dir.Name);
            }
            return list;
        }

        #region Scheme
        const string enabledMark = "Enabled";

        public static List<string> GetExistScheme()
        {
            var existScheme = XYIni.Package["ExistScheme"];
            var existSchemeList = existScheme.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries).ToList();
            return existSchemeList;
        }

        public static string GetCurrentScheme()
        {
            var scheme = XYIni.Package["CurrentScheme"];
            if (scheme.Length == 0)
            {
                scheme = "默认配置";
                XYIni.Package["CurrentScheme"] = scheme;
            }
            return scheme;
        }
        public static void SetCurrentScheme(string scheme)
        {
            XYIni.Package["CurrentScheme"] = scheme;
        }

        public static List<string> GetCurrentEnabled()
        {
            List<string> enabledList;

            var currentScheme = GetCurrentScheme();
            var enabledPackages = XYIni.Package[currentScheme + enabledMark];
            enabledList = enabledPackages.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries).ToList();
            return enabledList;
        }
        public static List<string> GetCurrentDisabled()
        {
            List<string> disabledList = new List<string>();

            var exist = GetExistPackage();
            var enabled = GetCurrentEnabled();
            foreach (var name in enabled)
                if (!exist.Contains(name))
                    disabledList.Add(name);

            return disabledList;
        }
        public static void PatchCurrentEnabled(List<string> enabledList)
        {
            var currentScheme = GetCurrentScheme();
            XYIni.Package[currentScheme + enabledMark] = string.Join(",", enabledList);
        }
        #endregion
    }
}
