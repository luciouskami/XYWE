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
        }
    }
}
