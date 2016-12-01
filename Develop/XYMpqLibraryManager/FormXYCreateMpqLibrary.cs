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

namespace XYMpqLibraryManager {
    public partial class FormXYCreateMpqLibrary : Form {
        public bool success = false;
        public string uiName = null;

        public FormXYCreateMpqLibrary() {
            InitializeComponent();
        }

        private void BtnEnter_Click(object sender, EventArgs e) {
            uiName = TbUILibraryName.Text;
            var pahtUI = XYPath.Dir.EditorShareMpqUi(uiName);
            if (uiName == "") {
                // Do Nothing
            }
            else if (XYMpq.IsExist(uiName)) {
                MessageBox.Show("已经存在同名UI：" + uiName);
            }
            else {
                XYMpq.Create(uiName);
                success = true;
                Dispose();
            }
        }

        private void BtnCancel_Click(object sender, EventArgs e) {
            success = false;
            Dispose();
        }
    }
}
