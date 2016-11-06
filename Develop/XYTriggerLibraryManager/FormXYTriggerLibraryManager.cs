using XYBase;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYTriggerLibraryManager
{
    public partial class FormXYTriggerLibraryManager : Form
    {
        #region Initialize Program
        public FormXYTriggerLibraryManager()
        {
            InitializeComponent();
        }
        List<string> listExist, listEnabled, listDisabled;
        #endregion

        #region Initialize Manager
        private void FormXYTriggerLibraryManager_Load(object sender, EventArgs e)
        {
            LoadScheme();
            LoadPackage();
            RefreshUI();
        }
        #endregion

        #region Change Using Library Configuration Scheme
        private void cbConfig_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
        #endregion

        #region Change Library State
        private void btnEnable_Click(object sender, EventArgs e)
        {
            var items = lbDisabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个未使用的触发库。");
                return;
            }

            EnablePackage((string)items[0]);
        }
        private void btnDisable_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            DisablePackage((string)items[0]);
        }
        #endregion

        #region Change Library Sequence
        private void btnUp_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            UpSelectPackage();
        }
        private void btnDown_Click(object sender, EventArgs e)
        {
            var items = lbEnabled.SelectedItems;
            if (items.Count != 1)
            {
                MessageBox.Show("必须选择一个使用中的触发库。");
                return;
            }

            DownSelectPackage();
        }
        #endregion

        #region Prevent Double Side Select
        bool lbDisabled_PreventNextChange = false;
        private void lbDisabled_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbDisabled_PreventNextChange)
            {
                lbDisabled_PreventNextChange = false;
                return;
            }

            if (lbEnabled.SelectedIndex != -1)
            {
                lbEnabled_PreventNextChange = true;
                lbEnabled.SelectedIndex = -1;
                lbEnabled.Refresh();
            }
        }
        bool lbEnabled_PreventNextChange = false;
        private void lbEnabled_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbEnabled_PreventNextChange)
            {
                lbEnabled_PreventNextChange = false;
                return;
            }

            if (lbDisabled.SelectedIndex != -1)
            {
                lbDisabled_PreventNextChange = true;
                lbDisabled.SelectedIndex = -1;
                lbDisabled.Refresh();
            }
        }
        #endregion

        void LoadScheme()
        {
            var currentScheme = XYPackage.GetCurrentScheme();
            if (currentScheme.Length == 0)
            {
                currentScheme = "默认配置";
            }

        }
        void LoadPackage()
        {
            listEnabled = XYPackage.GetCurrentEnabled();
            listDisabled = XYPackage.GetCurrentDisabled();
        }
        void RefreshUI()
        {
            UpdateDisabledPackageUI();
            UpdateEnabledPackageUI();
        }

        void EnablePackage(string name)
        {
            UpdateEnabledPackageData(name);
            UpdateEnabledPackageUI();
            UpdateDisabledPackageUI();
        }
        void DisablePackage(string name)
        {
            UpdateDisabledPackageData(name);
            UpdateEnabledPackageUI();
            UpdateDisabledPackageUI();
        }
        
        void UpdateEnabledPackageData(string name)
        {
            listEnabled.Add(name);
            listDisabled.Remove(name);
            XYPackage.PatchCurrentEnabled(listEnabled);
        }
        void UpdateDisabledPackageData(string name)
        {
            listEnabled.Remove(name);
            listDisabled.Add(name);
            XYPackage.PatchCurrentEnabled(listEnabled);
        }

        void UpdateEnabledPackageUI()
        {
            lbEnabled.Items.Clear();
            listEnabled.ForEach(name =>
            {
                lbEnabled.Items.Add(name);
            });
        }
        void UpdateDisabledPackageUI()
        {
            lbDisabled.Items.Clear();
            listDisabled.ForEach(name =>
            {
                lbDisabled.Items.Add(name);
            });
        }

        void UpSelectPackage()
        {
            var name = (string)lbEnabled.SelectedItem;
            var index = listEnabled.IndexOf(name);
            if (index > 0)
            {
                listEnabled.RemoveAt(index);
                listEnabled.Insert(index - 1, name);
                XYPackage.PatchCurrentEnabled(listEnabled);
                UpdateEnabledPackageUI();
                lbEnabled.SelectedIndex = index - 1;
            }
        }
        void DownSelectPackage()
        {
            var name = (string)lbEnabled.SelectedItem;
            var maxIndex = listEnabled.Count - 1;
            var index = listEnabled.IndexOf(name);
            if (index < maxIndex)
            {
                listEnabled.RemoveAt(index);
                listEnabled.Insert(index + 1, name);
                XYPackage.PatchCurrentEnabled(listEnabled);
                UpdateEnabledPackageUI();
                lbEnabled.SelectedIndex = index + 1;
            }
        }
    }
}
