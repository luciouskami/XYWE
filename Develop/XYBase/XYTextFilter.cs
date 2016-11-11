using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYTextFilter
    {
        /// <summary>
        /// 已被XYUpdater使用，不可变更旧功能
        /// </summary>
        public static string FilterVersionNameServerToLocal(string unfilteredVersionName)
        {
            return unfilteredVersionName
                .Replace("XYJL", "咸鱼降临");
        }
        /// <summary>
        /// 已被XYUpdater使用，不可变更旧功能
        /// </summary>
        public static string FilterVersionNameLocalToServer(string unfilteredVersionName)
        {
            return unfilteredVersionName
                .Replace("咸鱼降临", "XYJL");
        }
    }
}
