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
            SyncSource();
            // TODO 未来通过更新器推送触发器库功能，由于太庞大，因此延迟推送
            // SyncPackage();
        }
        static void SyncSource()
        {
            XYFile.SyncDirectory(XYPath.Dir.SourceJass, XYPath.Dir.EditorJass);
            XYFile.SyncDirectory(XYPath.Dir.SourceMpq, XYPath.Dir.EditorShareMpq);
            XYFile.SyncDirectory(XYPath.Dir.SourcePlugin, XYPath.Dir.EditorPlugin);
            XYFile.SyncDirectory(XYPath.Dir.SourceScript, XYPath.Dir.EditorShareScript,
                ignoreFileName: new[] { "uiloader.lua", "ydwe_on_startup.lua" });
        }
        static void SyncPackage()
        {
            var enabled = XYPackage.GetCurrentEnabled();
            for (int i = 0; i < enabled.Count; i++)
            {
                var name = enabled[i];
                var package = XYPath.Dir.SourcePackage + "\\" + name + "\\";
                var scriptSource = package + "script";
                var uiSource = package + "ui";
                var scriptTarget = XYPath.Dir.EditorJass + "\\package\\" + name;
                var uiTarget = XYPath.Dir.EditorShareMpq + "\\" + name + "\\ui";
                XYFile.SyncDirectory(scriptSource, scriptTarget);
                XYFile.SyncDirectory(uiSource, uiTarget);
            }

            var disabled = XYPackage.GetCurrentDisabled();
            foreach (var name in disabled)
            {
                var scriptTarget = XYPath.Dir.EditorJass + "\\package\\" + name;
                var uiTarget = XYPath.Dir.EditorShareMpq + "\\" + name; // 与上面不同的原因是在删除时要连ui本体目录一起删除
                XYFile.RemoveDirectory(scriptTarget);
                XYFile.RemoveDirectory(uiTarget);
            }
        }
    }
}
