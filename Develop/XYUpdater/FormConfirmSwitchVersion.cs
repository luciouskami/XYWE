/*
弹窗内容：
    √·显示目标版本
	·从服务端获取将要变更的文件的列表
	·从服务端获取将要变更的文件的总大小
	·询问用户是否备份（默认勾选），路径为./backup/时间 版本 - 版本
	√·红字提示用户，确认切换将会关闭所有运行中的WE和所有咸鱼工具
确认切换：
	·将变更的文件列表和文件总大小以及是否备份保存到本地ini中
	·关闭所有WE、咸鱼工具
	·启动更新执行器
*/
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using XYBase;

namespace XYUpdater
{
    public partial class FormConfirmSwitchVersion : Form
    {
        private string versionServerName;
        private string versionLocalName;

        public FormConfirmSwitchVersion(string versionLocalName)
        {
            InitializeComponent();
            this.versionLocalName = versionLocalName;
            this.versionServerName = XYTextFilter.FilterVersionNameLocalToServer(versionLocalName);
        }

        private void FormConfirmSwitchVersion_Load(object sender, EventArgs e)
        {
            tbTargetVersion.Text = versionLocalName;
            var now = DateTime.Now;
            cbBackup.Text = $"备份被变更的文件到\r\n"
                + $"{{XYWE根目录}}/backup/"
                + $"{now.Year}-{now.Month}-{now.Day} {now.Hour}-{now.Minute}-{now.Second}"
                + $" {XYInfo.VersionName} {XYInfo.Version} to {versionLocalName}";
        }
    }
}
