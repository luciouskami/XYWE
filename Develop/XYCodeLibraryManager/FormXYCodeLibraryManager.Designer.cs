namespace XYCodeLibraryManager {
    partial class FormXYCodeLibraryManager {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormXYCodeLibraryManager));
            this.LbCodeLibrary = new System.Windows.Forms.ListBox();
            this.BtnEditCodeLibraryMain = new System.Windows.Forms.Button();
            this.BtnBrowseCodeLibraryDirectory = new System.Windows.Forms.Button();
            this.BtnCreateCodeLibrary = new System.Windows.Forms.Button();
            this.BtnDeleteCodeLibrary = new System.Windows.Forms.Button();
            this.BtnPackCodeLibrary = new System.Windows.Forms.Button();
            this.BtnRefreshCodeLibrary = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // LbCodeLibrary
            // 
            this.LbCodeLibrary.FormattingEnabled = true;
            this.LbCodeLibrary.ItemHeight = 12;
            this.LbCodeLibrary.Location = new System.Drawing.Point(12, 12);
            this.LbCodeLibrary.Name = "LbCodeLibrary";
            this.LbCodeLibrary.Size = new System.Drawing.Size(151, 136);
            this.LbCodeLibrary.TabIndex = 0;
            // 
            // BtnEditCodeLibraryMain
            // 
            this.BtnEditCodeLibraryMain.Location = new System.Drawing.Point(169, 73);
            this.BtnEditCodeLibraryMain.Name = "BtnEditCodeLibraryMain";
            this.BtnEditCodeLibraryMain.Size = new System.Drawing.Size(168, 35);
            this.BtnEditCodeLibraryMain.TabIndex = 1;
            this.BtnEditCodeLibraryMain.Text = "编辑代码";
            this.BtnEditCodeLibraryMain.UseVisualStyleBackColor = true;
            this.BtnEditCodeLibraryMain.Click += new System.EventHandler(this.BtnEditCodeLibraryMain_Click);
            // 
            // BtnBrowseCodeLibraryDirectory
            // 
            this.BtnBrowseCodeLibraryDirectory.Location = new System.Drawing.Point(343, 73);
            this.BtnBrowseCodeLibraryDirectory.Name = "BtnBrowseCodeLibraryDirectory";
            this.BtnBrowseCodeLibraryDirectory.Size = new System.Drawing.Size(44, 35);
            this.BtnBrowseCodeLibraryDirectory.TabIndex = 2;
            this.BtnBrowseCodeLibraryDirectory.Text = "浏览\r目录";
            this.BtnBrowseCodeLibraryDirectory.UseVisualStyleBackColor = true;
            this.BtnBrowseCodeLibraryDirectory.Click += new System.EventHandler(this.BtnBrowseCodeLibraryDirectory_Click);
            // 
            // BtnCreateCodeLibrary
            // 
            this.BtnCreateCodeLibrary.Location = new System.Drawing.Point(169, 12);
            this.BtnCreateCodeLibrary.Name = "BtnCreateCodeLibrary";
            this.BtnCreateCodeLibrary.Size = new System.Drawing.Size(118, 35);
            this.BtnCreateCodeLibrary.TabIndex = 3;
            this.BtnCreateCodeLibrary.Text = "新建库";
            this.BtnCreateCodeLibrary.UseVisualStyleBackColor = true;
            this.BtnCreateCodeLibrary.Click += new System.EventHandler(this.BtnCreateCodeLibrary_Click);
            // 
            // BtnDeleteCodeLibrary
            // 
            this.BtnDeleteCodeLibrary.Location = new System.Drawing.Point(293, 12);
            this.BtnDeleteCodeLibrary.Name = "BtnDeleteCodeLibrary";
            this.BtnDeleteCodeLibrary.Size = new System.Drawing.Size(44, 35);
            this.BtnDeleteCodeLibrary.TabIndex = 4;
            this.BtnDeleteCodeLibrary.Text = "删除库";
            this.BtnDeleteCodeLibrary.UseVisualStyleBackColor = true;
            this.BtnDeleteCodeLibrary.Click += new System.EventHandler(this.BtnDeleteCodeLibrary_Click);
            // 
            // BtnPackCodeLibrary
            // 
            this.BtnPackCodeLibrary.Location = new System.Drawing.Point(343, 12);
            this.BtnPackCodeLibrary.Name = "BtnPackCodeLibrary";
            this.BtnPackCodeLibrary.Size = new System.Drawing.Size(44, 35);
            this.BtnPackCodeLibrary.TabIndex = 5;
            this.BtnPackCodeLibrary.Text = "打包库";
            this.BtnPackCodeLibrary.UseVisualStyleBackColor = true;
            this.BtnPackCodeLibrary.Click += new System.EventHandler(this.BtnPackCodeLibrary_Click);
            // 
            // BtnRefreshCodeLibrary
            // 
            this.BtnRefreshCodeLibrary.Location = new System.Drawing.Point(169, 114);
            this.BtnRefreshCodeLibrary.Name = "BtnRefreshCodeLibrary";
            this.BtnRefreshCodeLibrary.Size = new System.Drawing.Size(218, 35);
            this.BtnRefreshCodeLibrary.TabIndex = 6;
            this.BtnRefreshCodeLibrary.Text = "刷新库";
            this.BtnRefreshCodeLibrary.UseVisualStyleBackColor = true;
            this.BtnRefreshCodeLibrary.Click += new System.EventHandler(this.BtnRefreshCodeLibrary_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 211);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(317, 12);
            this.label1.TabIndex = 7;
            this.label1.Text = "* 刷新库后会在下一次地图保存时即时生效，不需要重启WE";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.ForeColor = System.Drawing.Color.Red;
            this.label2.Location = new System.Drawing.Point(12, 177);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(317, 12);
            this.label2.TabIndex = 8;
            this.label2.Text = "* 必须使用public标记公开的函数，且每行只能有一个函数";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.Color.Red;
            this.label3.Location = new System.Drawing.Point(12, 194);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(377, 12);
            this.label3.TabIndex = 9;
            this.label3.Text = "* 不要编辑库目录下的{name}.cfg和{name}.j，除非你知道它们的作用";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.ForeColor = System.Drawing.Color.Red;
            this.label4.Location = new System.Drawing.Point(12, 160);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(137, 12);
            this.label4.TabIndex = 10;
            this.label4.Text = "* 编辑代码后必须刷新库";
            // 
            // FormXYCodeLibraryManager
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(399, 235);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.BtnRefreshCodeLibrary);
            this.Controls.Add(this.BtnPackCodeLibrary);
            this.Controls.Add(this.BtnDeleteCodeLibrary);
            this.Controls.Add(this.BtnCreateCodeLibrary);
            this.Controls.Add(this.BtnBrowseCodeLibraryDirectory);
            this.Controls.Add(this.BtnEditCodeLibraryMain);
            this.Controls.Add(this.LbCodeLibrary);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "FormXYCodeLibraryManager";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "咸鱼代码库管理器";
            this.Activated += new System.EventHandler(this.FormXYCodeLibraryManager_Activated);
            this.Load += new System.EventHandler(this.FormXYCodeLibraryManager_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox LbCodeLibrary;
        private System.Windows.Forms.Button BtnEditCodeLibraryMain;
        private System.Windows.Forms.Button BtnBrowseCodeLibraryDirectory;
        private System.Windows.Forms.Button BtnCreateCodeLibrary;
        private System.Windows.Forms.Button BtnDeleteCodeLibrary;
        private System.Windows.Forms.Button BtnPackCodeLibrary;
        private System.Windows.Forms.Button BtnRefreshCodeLibrary;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
    }
}