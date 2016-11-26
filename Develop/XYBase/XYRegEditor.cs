using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Win32;

namespace XYBase
{
    public static class XYRegEditor
    {
        public static void SetWERecentMapPath0(string path)
        {
            Registry.SetValue(
                @"HKEY_CURRENT_USER\Software\Blizzard Entertainment\WorldEdit",
                "Recent Document 00",
                path);
        }
    }
}
