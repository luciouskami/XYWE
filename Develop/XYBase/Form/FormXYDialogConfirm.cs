using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYBase
{
    public partial class FormXYDialogConfirm : Form
    {
        private const string stopNoticeConfigPrefix = "StopNotice-"; // eg. StopNotice-ReportBug

        private string configFullName;
        private bool canNotice
        {
            get
            {
                string value = XYIni.Config[configFullName];
                if (value == "") value = "False";

                bool stopNotice = Convert.ToBoolean(value);
                return !stopNotice;
            }
            set
            {
                XYIni.Config[configFullName] = Convert.ToString(value);
            }
        }

        /// <summary>
        /// configName: 如"ReportBug"
        /// </summary>
        public FormXYDialogConfirm(XYDialogType configName, string message, Action actionOnConfirm = null, Action actionOnCancel = null)
        {
            configFullName = stopNoticeConfigPrefix + Enum.GetName(typeof(XYDialogType), configName);
            ActionOnConfirm = actionOnConfirm;
            ActionOnCancel = actionOnCancel;
            if (canNotice)
            {
                InitializeComponent();
                tbMessage.Text = message;
                tbMessage.Select(tbMessage.TextLength, 0);
            }
            else
            {
                Shown += FormXYDialogConfirm_DisposeOnShow;
            }
        }

        private void FormXYDialogConfirm_DisposeOnShow(object sender, EventArgs e)
        {
            ActionOnConfirm?.Invoke();
            Dispose();
        }

        public Action ActionOnConfirm;
        public Action ActionOnCancel;

        private void btnConfirm_Click(object sender, EventArgs e)
        {
            ActionOnConfirm?.Invoke();
            Dispose();
        }
        private void btnCancel_Click(object sender, EventArgs e)
        {
            ActionOnCancel?.Invoke();
            Dispose();
        }

        private void cbStopNotice_CheckedChanged(object sender, EventArgs e)
        {
            XYIni.Config[configFullName] = Convert.ToString(cbStopNotice.Checked);
        }
    }
}
