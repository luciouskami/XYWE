using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace XYBase
{
    public static class XYProcess
    {
        public static class Application
        {
            static void KillApplications(string name)
            {
                var group = Process.GetProcessesByName(name);
                foreach (var proc in group) proc.Kill();
            }
            static void KillApplications(string[] names)
            {
                foreach (var name in names) KillApplications(name);
            }

            // TODO It doesn't working
            public static void KillXYWEApplications()
            {
                KillApplications(new[]
                {
                    "worldeditydwe.exe",

                    "XYCodeLibraryManager.exe",
                    "XYMpqLibraryManager.exe",
                    "XYChecker.exe",
                    "XYTextColorMaker.exe",
                    "XYTriggerSyntaxHighlighter.exe",
                    "XYTriggerLibraryManager.exe",
                });
            }

            public static void StartXYWE()
            {
                Process.Start(@"editor\YDWE.exe");
            }

            public static void StartXYCodeLibraryManager()
            {
                Process.Start(@"XYCodeLibraryManager.exe");
            }

            public static void StartXYMpqLibraryManager()
            {
                Process.Start(@"XYMpqLibraryManager.exe");
            }

            public static void StartXYChecker()
            {
                Process.Start(@"XYChecker.exe");
            }

            public static void StartXYTextColorMaker()
            {
                Process.Start(@"XYTextColorMaker.exe");
            }

            public static void StartXYTriggerSyntaxHighlighter()
            {
                Process.Start(@"XYTriggerSyntaxHighlighter.exe");
            }

            public static void StartXYTriggerLibraryManager()
            {
                Process.Start(@"XYTriggerLibraryManager.exe");
            }
        }
        public static class Website
        {
            public static void StartOfficial()
            {
                Process.Start("https://wow9.org/xywe");
            }
            public static void StartCommunity()
            {
                Process.Start("https://wow9.org/forum.php?mod=forumdisplay&fid=122");
            }
            public static void StartXyWikiVersion(string version)
            {
                Process.Start("https://xywiki.com/p/XYWE:" + version);
            }
            public static void StartOnlineRoomWow8()
            {
                Process.Start("http://bbs.wow8.org/forum.php?mod=forumdisplay&fid=489");
            }
            public static void StartOnlineRoomWow9()
            {
                Process.Start("https://wow9.org/forum.php?mod=forumdisplay&fid=123");
            }
        }
    }
}
