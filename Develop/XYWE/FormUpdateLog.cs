using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using XYBase;

namespace XYWE
{
    public partial class FormUpdateLog : Form
    {
        public FormUpdateLog()
        {
            InitializeComponent();
            lbVersion.Text = XYInfo.Version;
            tbLog.Text = File.ReadAllText(XYPath.File.DataUpdateLog);
            Disposed += FormUpdateLog_Disposed;
        }

        private void FormUpdateLog_Disposed(object sender, EventArgs e)
        {
            Directory.Delete(XYPath.Dir.DataUpdate, true);
        }

        private void btnConfirm_Click(object sender, EventArgs e)
        {
            Close();
            Dispose();
        }

        private void btnMore_Click(object sender, EventArgs e)
        {
            XYProcess.Website.StartXyWikiVersion(XYInfo.Version);
        }
    }
}
