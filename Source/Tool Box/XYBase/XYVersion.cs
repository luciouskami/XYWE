using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYVersion
    {
        public static void VerifyObsoleteAsync(Action obsoleteAction)
        {
            if (Convert.ToBoolean(XYIni.Config["Obsolete"]))
            {
                obsoleteAction();
                return;
            }

            // Only check once per whole day
            if (DateTime.Now.Subtract(DateTime.Parse(XYIni.Config["LastCheckObsoleteTime"])).Days == 0) return;
            XYIni.Config["LastCheckObsoleteTime"] = DateTime.Now.ToString();

            XYWeb.DownloadXYWikiTextAsync("最新版本", data =>
            {
                if (data[0] != XYInfo.Version)
                {
                    XYIni.Config["Obsolete"] = "true";
                    obsoleteAction();
                }
            });
        }
    }
}
