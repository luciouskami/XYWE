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

        public static List<string> GetExist()
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
        public static List<string> GetEnabled()
        {
            List<string> enabledList;

            var enabledPackages = XYIni.Package["Enabled"];
            enabledList = enabledPackages.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries).ToList();
            return enabledList;
        }
        public static List<string> GetDisabled()
        {
            List<string> disabledList = new List<string>();

            var exist = GetExist();
            var enabled = GetEnabled();
            foreach (var name in enabled)
                if (!exist.Contains(name))
                    disabledList.Add(name);

            return disabledList;
        }
        public static void PatchEnable(List<string> enablePackageList)
        {
            XYIni.Package["Enabled"] = string.Join(",", enablePackageList);
        }
    }
}
