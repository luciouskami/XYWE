namespace XYMpqLibraryManager {
    partial class FormXYMpqLibraryManager {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent() {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormXYMpqLibraryManager));
            this.ClbUI = new System.Windows.Forms.CheckedListBox();
            this.BtnEditClass = new System.Windows.Forms.Button();
            this.BtnEditFunction = new System.Windows.Forms.Button();
            this.BtnRefreshLibraryUI = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.BtnCreate = new System.Windows.Forms.Button();
            this.BtnDelete = new System.Windows.Forms.Button();
            this.BtnBrowseDirectory = new System.Windows.Forms.Button();
            this.BtnHigher = new System.Windows.Forms.Button();
            this.BtnLower = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // ClbUI
            // 
            this.ClbUI.FormattingEnabled = true;
            this.ClbUI.Location = new System.Drawing.Point(12, 12);
            this.ClbUI.Name = "ClbUI";
            this.ClbUI.Size = new System.Drawing.Size(137, 196);
            this.ClbUI.TabIndex = 0;
            this.ClbUI.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.ClbUI_ItemCheck);
            this.ClbUI.SelectedIndexChanged += new System.EventHandler(this.ClbUI_SelectedIndexChanged);
            // 
            // BtnEditClass
            // 
            this.BtnEditClass.Location = new System.Drawing.Point(187, 78);
            this.BtnEditClass.Name = "BtnEditClass";
            this.BtnEditClass.Size = new System.Drawing.Size(126, 31);
            this.BtnEditClass.TabIndex = 1;
            this.BtnEditClass.Text = "编辑分类表";
            this.BtnEditClass.UseVisualStyleBackColor = true;
            this.BtnEditClass.Click += new System.EventHandler(this.BtnEditClass_Click);
            // 
            // BtnEditFunction
            // 
            this.BtnEditFunction.Location = new System.Drawing.Point(187, 115);
            this.BtnEditFunction.Name = "BtnEditFunction";
            this.BtnEditFunction.Size = new System.Drawing.Size(126, 31);
            this.BtnEditFunction.TabIndex = 2;
            this.BtnEditFunction.Text = "编辑函数表";
            this.BtnEditFunction.UseVisualStyleBackColor = true;
            this.BtnEditFunction.Click += new System.EventHandler(this.BtnEditFunction_Click);
            // 
            // BtnRefreshLibraryUI
            // 
            this.BtnRefreshLibraryUI.Location = new System.Drawing.Point(187, 165);
            this.BtnRefreshLibraryUI.Name = "BtnRefreshLibraryUI";
            this.BtnRefreshLibraryUI.Size = new System.Drawing.Size(159, 43);
            this.BtnRefreshLibraryUI.TabIndex = 3;
            this.BtnRefreshLibraryUI.Text = "刷新UI";
            this.BtnRefreshLibraryUI.UseVisualStyleBackColor = true;
            this.BtnRefreshLibraryUI.Click += new System.EventHandler(this.BtnRefreshLibraryUI_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.ForeColor = System.Drawing.Color.Red;
            this.label1.Location = new System.Drawing.Point(12, 234);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(137, 12);
            this.label1.TabIndex = 4;
            this.label1.Text = "UI编辑后必须刷新才有效";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.ForeColor = System.Drawing.Color.Red;
            this.label2.Location = new System.Drawing.Point(12, 251);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(149, 12);
            this.label2.TabIndex = 5;
            this.label2.Text = "UI刷新后必须重启WE才生效";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.Color.Red;
            this.label3.Location = new System.Drawing.Point(12, 217);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(197, 12);
            this.label3.TabIndex = 9;
            this.label3.Text = "禁止直接编辑share/mpq/config文件";
            // 
            // BtnCreate
            // 
            this.BtnCreate.Location = new System.Drawing.Point(187, 12);
            this.BtnCreate.Name = "BtnCreate";
            this.BtnCreate.Size = new System.Drawing.Size(126, 46);
            this.BtnCreate.TabIndex = 10;
            this.BtnCreate.Text = "创建UI";
            this.BtnCreate.UseVisualStyleBackColor = true;
            this.BtnCreate.Click += new System.EventHandler(this.BtnCreate_Click);
            // 
            // BtnDelete
            // 
            this.BtnDelete.Location = new System.Drawing.Point(319, 12);
            this.BtnDelete.Name = "BtnDelete";
            this.BtnDelete.Size = new System.Drawing.Size(27, 46);
            this.BtnDelete.TabIndex = 11;
            this.BtnDelete.Text = "删除UI";
            this.BtnDelete.UseVisualStyleBackColor = true;
            this.BtnDelete.Click += new System.EventHandler(this.BtnDelete_Click);
            // 
            // BtnBrowseDirectory
            // 
            this.BtnBrowseDirectory.Location = new System.Drawing.Point(319, 78);
            this.BtnBrowseDirectory.Name = "BtnBrowseDirectory";
            this.BtnBrowseDirectory.Size = new System.Drawing.Size(27, 68);
            this.BtnBrowseDirectory.TabIndex = 12;
            this.BtnBrowseDirectory.Text = "浏览目录";
            this.BtnBrowseDirectory.UseVisualStyleBackColor = true;
            this.BtnBrowseDirectory.Click += new System.EventHandler(this.BtnBrowseDirectory_Click);
            // 
            // BtnHigher
            // 
            this.BtnHigher.Location = new System.Drawing.Point(155, 12);
            this.BtnHigher.Name = "BtnHigher";
            this.BtnHigher.Size = new System.Drawing.Size(26, 97);
            this.BtnHigher.TabIndex = 13;
            this.BtnHigher.Text = "↑";
            this.BtnHigher.UseVisualStyleBackColor = true;
            this.BtnHigher.Click += new System.EventHandler(this.BtnHigher_Click);
            // 
            // BtnLower
            // 
            this.BtnLower.Location = new System.Drawing.Point(155, 115);
            this.BtnLower.Name = "BtnLower";
            this.BtnLower.Size = new System.Drawing.Size(26, 93);
            this.BtnLower.TabIndex = 14;
            this.BtnLower.Text = "↓";
            this.BtnLower.UseVisualStyleBackColor = true;
            this.BtnLower.Click += new System.EventHandler(this.BtnLower_Click);
            // 
            // FormXYMpqLibraryManager
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(358, 274);
            this.Controls.Add(this.BtnLower);
            this.Controls.Add(this.BtnHigher);
            this.Controls.Add(this.BtnBrowseDirectory);
            this.Controls.Add(this.BtnDelete);
            this.Controls.Add(this.BtnCreate);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.BtnRefreshLibraryUI);
            this.Controls.Add(this.BtnEditFunction);
            this.Controls.Add(this.BtnEditClass);
            this.Controls.Add(this.ClbUI);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "FormXYMpqLibraryManager";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "咸鱼UI管理器";
            this.Activated += new System.EventHandler(this.FormXYMpqLibraryManager_Activated);
            this.Load += new System.EventHandler(this.FormXYMpqLibraryManager_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.CheckedListBox ClbUI;
        private System.Windows.Forms.Button BtnEditClass;
        private System.Windows.Forms.Button BtnEditFunction;
        private System.Windows.Forms.Button BtnRefreshLibraryUI;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button BtnCreate;
        private System.Windows.Forms.Button BtnDelete;
        private System.Windows.Forms.Button BtnBrowseDirectory;
        private System.Windows.Forms.Button BtnHigher;
        private System.Windows.Forms.Button BtnLower;
    }
}

