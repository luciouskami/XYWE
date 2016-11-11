/*
特性：
    相对独立性：
        ·更新器使用过的所有XYBase接口不可变更，否则会导致兼容性问题
        ·更新器的所有功能必须保证相对于其他所有组件独立，即仅替换exe即可更新更新器
    强制最新：
        ·每次运行更新器前，会强制检查是否存在新的更新器，如果存在，则强制对更新器进行更新
            ·关闭自身并立即以Updater模式启动Executor，该模式下Executor仅对Updater进行更新，且UI与正常模式不同
功能：
	验证最新：
	    √·验证服务端的最新版本号，如果与存在的本地缓存不符合，则更新列表文件
	    √·更新的列表文件会被永久缓存，直到发现新的版本号
    显示列表：
        √·如果本地列表中的最新版与服务端的最新版本号相同，则从缓存中读取版本列表
        √·如果本地列表中的最新版与服务端的最新版本号不同，则从服务端获取新的版本列表并永久缓存到本地
        ·（考虑）自动选择与本地版本相同的版本
	查看日志：
	    √·在用户点击版本号时尝试下载版本日志
	    √·日志会在下载时被HttpClient缓存30天
	切换版本：
	    √·用户点击切换版本时，显示确认切换弹窗
    禁止向基版本以下兼容（暂）：
        ·旧版本的XYBase.dll不存在更新器模块，向下更新将会导致更新器无法使用
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
using System.Net.Http;
using XYBase;
using System.Text.RegularExpressions;

namespace XYUpdater
{
    public partial class FormXYUpdater : Form
    {
        public FormXYUpdater()
        {
            InitializeComponent();
        }

        private void FormXYUpdater_Load(object sender, EventArgs e)
        {
            TryUpdateSelf();
            ExecuteVersionConfirmUpdate();
        }

        private void TryUpdateSelf()
        {
            // TODO 强制自我更新
            // throw new NotImplementedException();
        }

        /// <summary>
        /// 验证服务器与本地的最新版本号，验证完成后才确定是否下载服务器列表文件或者使用本地缓存列表文件
        /// </summary>
        private void ExecuteVersionConfirmUpdate()
        {
            var localVersion = XYCache.GetNewestVersionOfLocalList();
            Server.GetNewestVersion(serverVersion =>
            {
                tbHint.Text = "";
                if (localVersion == serverVersion)
                {
                    // 本地缓存的最新版本与服务器的最新版本相同，使用缓存的版本列表
                    LoadCacheVersionList();
                }
                else
                {
                    // 服务器发布了新的版本，更新版本列表
                    XYCache.SetNewestVersionOfLocalList(serverVersion);
                    LoadServerVersionList();
                }
            }, retry =>
            {
                tbHint.Text = $"获取服务器版本信息失败，正在重试：{retry} / 5";
            }, () =>
            {
                tbHint.Text = "获取版本信息失败，请检查网络链接或者反馈BUG";
            });
            // TODO 考虑允许在链接服务器失败的情况下使用本地数据缓存（离线模式）
        }

        private void LoadCacheVersionList()
        {
            var versionList = XYCache.GetLocalVersionList();
            lbVersion.Items.Clear();
            lbVersion.Items.AddRange(versionList);
        }

        private void LoadServerVersionList()
        {
            Server.GetVersionList(versionList =>
            {
                tbHint.Text = "";
                lbVersion.Items.Clear();
                for (int i = 0; i < versionList.Length; i++)
                {
                    versionList[i] = XYTextFilter.FilterVersionNameServerToLocal(versionList[i]);
                }
                lbVersion.Items.AddRange(versionList);
                XYCache.SetLocalVersionList(versionList);
            }, retry =>
            {
                tbHint.Text = $"获取列表信息失败，正在重试：{retry} / 5";
            }, () =>
            {
                tbHint.Text = "获取列表信息失败，请检查网络链接或者反馈BUG";
            });
        }

        private void lbVersion_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (VersionUnselected()) return;

            var serverVersionName = XYTextFilter.FilterVersionNameLocalToServer((string)lbVersion.SelectedItem);
            MessageBox.Show(serverVersionName);
            Server.GetVersionLog((serverVersionName), log =>
            {
                tbHint.Text = "";
                tbLog.Text = log;
            }, retry =>
            {
                tbHint.Text = $"获取日志信息失败，正在重试：{retry} / 5";
            }, () =>
            {
                tbHint.Text = $"获取日志信息失败，请\r\n- 检查网络链接\r\n- 反馈BUG";
            });
        }

        #region Confirm Switch Version
        FormConfirmSwitchVersion formConfirm = null;
        private void btnDoSwitch_Click(object sender, EventArgs e)
        {
            if (VersionUnselected())
            {
                MessageBox.Show("你必须先选择一个版本。");
                return;
            }
            if (formConfirm != null)
            {
                MessageBox.Show("你已经点击过切换版本了。");
                return;
            }
            formConfirm = new FormConfirmSwitchVersion(GetSelectedVersion());
            formConfirm.Show();
            formConfirm.FormClosed += FormConfirm_FormClosed;
        }
        private void FormConfirm_FormClosed(object sender, FormClosedEventArgs e)
        {
            formConfirm = null;
        }
        #endregion

        private string GetSelectedVersion()
        {
            return (string)lbVersion.SelectedItem;
        }
        private bool VersionUnselected()
        {
            return lbVersion.SelectedItem == null || ((string)lbVersion.SelectedItem).Length == 0;
        }
    }
}
