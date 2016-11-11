/*
咸鱼更新执行器：
    完全独立性：
        与咸鱼更新器不同，执行器必须保证完全独立性，不可使用任何与XYWE相关的函数或功能，因为执行器需要权限对XYWE本身进行完全更新。
    固定性：
        完成编写后永远不更改原有功能，可添加额外功能但必须保证原有功能不变。
    功能：
	    根据ini备份将要变更的文件（提醒可以在./backup/XXXX下找到）
	    根据ini从服务端下载差异文件
	    根据已下载差异文件大小来推进进度条以及下载数量进度
	    根据当前网速估算剩余时间
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

namespace XYUpdateExecutor
{
    public partial class FormXYUpdateExecutor : Form
    {
        public FormXYUpdateExecutor()
        {
            InitializeComponent();
        }
    }
}
