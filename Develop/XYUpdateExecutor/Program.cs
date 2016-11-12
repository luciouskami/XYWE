using System;
using System.Diagnostics;
using System.Threading;
using System.Windows.Forms;

namespace XYUpdateExecutor
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            // Keep UNIQUE
            // http://stackoverflow.com/questions/184084/how-to-force-c-sharp-net-app-to-run-only-one-instance-in-windows

            bool createdNew = true;
            using (Mutex mutex = new Mutex(true, "XYUpdateExecutor.exe", out createdNew))
            {
                if (createdNew)
                {
                    Application.EnableVisualStyles();
                    Application.SetCompatibleTextRenderingDefault(false);
                    Application.Run(new FormXYUpdateExecutor());
                }
                else
                {
                    Process.GetCurrentProcess().Kill();
                }
            }
        }
    }
}