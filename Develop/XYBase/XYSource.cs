using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYSource
    {
        public static void RefreshEditor()
        {
            
        }
        static void SyncJass()
        {
            XYFile.SyncDirectory(XYPath.Dir.SourceJass, XYPath.Dir.EditorJass);
        }
        static void SyncScript()
        {
        }
    }
}
