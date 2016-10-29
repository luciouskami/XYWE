// http://www.cnblogs.com/pccai/archive/2011/03/08/1977692.html

using System.Diagnostics;

namespace XYWELauncher
{
    class Program
    {
        static void Main(string[] args)
        {
            var info = new ProcessStartInfo("XYWE.exe");
            info.WorkingDirectory = @"core\xywe";
            Process.Start(info);
        }
    }
}