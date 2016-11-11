using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace XYWE
{
    public partial class FormAnnouncement : Form
    {
        public FormAnnouncement(string announcement)
        {
            InitializeComponent();
            textBox1.Text = announcement;
            textBox1.Select(0, 0);
        }
    }
}
