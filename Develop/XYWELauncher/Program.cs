// About Launch: http://www.cnblogs.com/pccai/archive/2011/03/08/1977692.html

// Determine Start XYWE or Execute Updater by is there a "update need" file

using System.IO;
using System.Diagnostics;
using System;

namespace XYWELauncher
{
    class Program
    {
        static void Main(string[] args)
        {
            string name = args.Length > 0 && args[0] == "Develop" ? "XYDevelop.exe" : "XYWE.exe";
            string dir = "core";

            if (name == "XYWE.exe" && File.Exists(dir + "/data/updateRequire.txt"))
            {
                name = "XYUpdater.exe";
            }

            if (File.Exists(dir + "/" + name))
            {
                var info = new ProcessStartInfo(name);
                info.WorkingDirectory = dir;
                Process.Start(info);
            }
            else
            {
                Console.WriteLine("File Not Exist: " + dir + "/" + name);
                Console.ReadKey();
            }
        }
    }
}