using System;
using System.Windows.Forms;
using System.Threading;
using System.Diagnostics;

namespace XYChecker
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            // Keep UNIQUE
            // http://stackoverflow.com/questions/184084/how-to-force-c-sharp-net-app-to-run-only-one-instance-in-windows

            bool createdNew = true;
            using (Mutex mutex = new Mutex(true, "XYChecker.exe", out createdNew))
            {
                if (createdNew)
                {
                    Application.EnableVisualStyles();
                    Application.SetCompatibleTextRenderingDefault(false);
                    Application.Run(new FormXYChecker());
                }
                else
                {
                    Process current = Process.GetCurrentProcess();
                    current.Kill();
                }
            }
        }
    }
}
