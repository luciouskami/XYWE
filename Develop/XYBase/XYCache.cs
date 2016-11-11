using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYCache
    {
        /// <summary>
        /// 不可更改，已被XYUpdater使用
        /// </summary>
        public static string GetNewestVersionOfLocalList()
        {
            return XYIni.Cache["NewestVersionOfLocalList"];
        }
        /// <summary>
        /// 不可更改，已被XYUpdater使用
        /// </summary>
        public static void SetNewestVersionOfLocalList(string value)
        {
            XYIni.Cache["NewestVersionOfLocalList"] = value;
        }

        /// <summary>
        /// 不可更改，已被XYUpdater使用
        /// </summary>
        public static string[] GetLocalVersionList()
        {
            return XYIni.Cache["LocalVersionList"].Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries);
        }
        /// <summary>
        /// 不可更改，已被XYUpdater使用
        /// </summary>
        public static void SetLocalVersionList(string[] versionList)
        {
            XYIni.Cache["LocalVersionList"] = string.Join(",", versionList);
        }
    }
}
