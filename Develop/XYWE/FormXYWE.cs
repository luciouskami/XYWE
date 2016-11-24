using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using XYBase;
using XYBase.XYForm;

namespace XYWE
{
    public partial class FormXYWE : Form
    {
        public FormXYWE()
        {
            if (!File.Exists(XYPath.File.UpdateLock) && File.Exists(XYPath.File.DataUpdateLog))
            {
                var formLog = new FormUpdateLog();
                formLog.ShowDialog();
            }
            XYWeb.ReadXyweServerTextAsync("announcement/last.txt", lastAnnouncementId =>
            {
                if (lastAnnouncementId == XYAnnouncement.GetLocalAnnouncementId()) return;

                XYAnnouncement.SetLocalAnnouncementId(lastAnnouncementId);
                XYWeb.ReadXyweServerTextAsync($"announcement/{lastAnnouncementId}.txt", announcement =>
                {
                    var formAnnouncement = new FormAnnouncement(announcement);
                    formAnnouncement.ShowDialog();
                }, null, null);
            }, null, null, 0);
            InitializeComponent();
            XYFile.RemoveDirectory(XYPath.Dir.DataUpdate);
            if (!File.Exists(XYPath.File.UpdateLock)) XYProcess.Application.StartXYChecker();
        }

        void FormXYWE_Load(object sender, EventArgs e)
        {
            LlVersion.Text = XYInfo.Version;
            XYTip.UpdateTipAsync();
            cbUI.SelectedItem = XYConfig.GetCurrentStandardUI();
        }

        void LlVersion_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            XYProcess.Website.StartOfficial();
        }

        void BtnStartXYWE_Click(object sender, EventArgs e)
        {
            SafeStart();
        }

        async void SafeStart()
        {
            // Change Text
            var text = BtnStartXYWE.Text;
            BtnStartXYWE.Text = "正在启动XYWE……";
            BtnStartXYWE.Enabled = false;
            BtnStartXYWE.Refresh(); // http://stackoverflow.com/questions/570537/update-label-while-processing-in-windows-forms

            // Refresh Tip
            XYTip.Refresh();

            // Refresh Editor Source
            XYSource.RefreshEditor();

            // Compile
            await Task.Run(() => { XYFile.Compile(XYPath.Dir.Source); });

            // Refresh Enabled Package UI Config
            XYConfig.RefreshConfig();

            // Recover Text
            BtnStartXYWE.Enabled = true;
            BtnStartXYWE.Text = text;

            // Start XYWE
            XYProcess.Application.StartXYWE();
        }

        void BtnXYCodeLibraryManager_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYCodeLibraryManager();
        }

        void BtnXYUILibraryManager_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYMpqLibraryManager();
        }

        private void BtnXYTextColorMaker_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYTextColorMaker();
        }

        private void BtnXYTriggerSyntaxHighlighter_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYTriggerSyntaxHighlighter();
        }

        private void btnLibrary_Click(object sender, EventArgs e)
        {
            XYProcess.Application.StartXYTriggerLibraryManager();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            FormXYDialogConfirm dialog = new FormXYDialogConfirm(
                XYDialogType.ReportBug,
                "你正在试图反馈BUG！\r\n但这个BUG很可能已经被解决过了。\r\n在你真正决定反馈BUG之前，请先查看根目录下的说用说明和崩溃解决方法，这也许能更快解决你的问题。",
                XYProcess.Website.StartCommunity);
            dialog.ShowDialog();
        }

        private void btnPatchUI_Click(object sender, EventArgs e)
        {
            var ui = (string)cbUI.SelectedItem;
            switch (ui)
            {
                case "XYWE": XYConfig.TurnXYWE(); break;
                case "YDWE": XYConfig.TurnYDWE(); break;
                default: throw new KeyNotFoundException("没有找到UI配置：" + ui);
            }
            MessageBox.Show("成功切换UI：" + ui);
        }
    }
}
