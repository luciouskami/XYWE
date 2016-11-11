using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYAnnouncement
    {
        public static void SetLocalAnnouncementId(string id)
        {
            XYIni.Config["LocalAnnouncementId"] = id;
        }
        public static string GetLocalAnnouncementId()
        {
            var id = XYIni.Config["LocalAnnouncementId"];
            if (id == "") XYIni.Config["LocalAnnouncementId"] = id;
            return id;
        }
    }
}
