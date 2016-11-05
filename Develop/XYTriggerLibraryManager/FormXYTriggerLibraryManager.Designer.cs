namespace XYTriggerLibraryManager
{
    partial class FormXYTriggerLibraryManager
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.lbDisabled = new System.Windows.Forms.ListBox();
            this.label2 = new System.Windows.Forms.Label();
            this.lbEnabled = new System.Windows.Forms.ListBox();
            this.btnUp = new System.Windows.Forms.Button();
            this.btnDown = new System.Windows.Forms.Button();
            this.btnEnable = new System.Windows.Forms.Button();
            this.btnDisable = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(51, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "未使用的触发库";
            // 
            // lbDisabled
            // 
            this.lbDisabled.FormattingEnabled = true;
            this.lbDisabled.ItemHeight = 12;
            this.lbDisabled.Location = new System.Drawing.Point(12, 38);
            this.lbDisabled.Name = "lbDisabled";
            this.lbDisabled.Size = new System.Drawing.Size(169, 280);
            this.lbDisabled.TabIndex = 2;
            this.lbDisabled.SelectedIndexChanged += new System.EventHandler(this.lbDisabled_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(427, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(89, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "使用中的触发库";
            // 
            // lbEnabled
            // 
            this.lbEnabled.FormattingEnabled = true;
            this.lbEnabled.ItemHeight = 12;
            this.lbEnabled.Location = new System.Drawing.Point(389, 38);
            this.lbEnabled.Name = "lbEnabled";
            this.lbEnabled.Size = new System.Drawing.Size(169, 280);
            this.lbEnabled.TabIndex = 4;
            this.lbEnabled.SelectedIndexChanged += new System.EventHandler(this.lbEnabled_SelectedIndexChanged);
            // 
            // btnUp
            // 
            this.btnUp.Location = new System.Drawing.Point(355, 38);
            this.btnUp.Name = "btnUp";
            this.btnUp.Size = new System.Drawing.Size(28, 107);
            this.btnUp.TabIndex = 5;
            this.btnUp.Text = "↑";
            this.btnUp.UseVisualStyleBackColor = true;
            this.btnUp.Click += new System.EventHandler(this.btnUp_Click);
            // 
            // btnDown
            // 
            this.btnDown.Location = new System.Drawing.Point(355, 211);
            this.btnDown.Name = "btnDown";
            this.btnDown.Size = new System.Drawing.Size(28, 107);
            this.btnDown.TabIndex = 6;
            this.btnDown.Text = "↓";
            this.btnDown.UseVisualStyleBackColor = true;
            this.btnDown.Click += new System.EventHandler(this.btnDown_Click);
            // 
            // btnEnable
            // 
            this.btnEnable.Location = new System.Drawing.Point(187, 162);
            this.btnEnable.Name = "btnEnable";
            this.btnEnable.Size = new System.Drawing.Size(37, 35);
            this.btnEnable.TabIndex = 7;
            this.btnEnable.Text = "+";
            this.btnEnable.UseVisualStyleBackColor = true;
            this.btnEnable.Click += new System.EventHandler(this.btnEnable_Click);
            // 
            // btnDisable
            // 
            this.btnDisable.Location = new System.Drawing.Point(346, 162);
            this.btnDisable.Name = "btnDisable";
            this.btnDisable.Size = new System.Drawing.Size(37, 35);
            this.btnDisable.TabIndex = 8;
            this.btnDisable.Text = "-";
            this.btnDisable.UseVisualStyleBackColor = true;
            this.btnDisable.Click += new System.EventHandler(this.btnDisable_Click);
            // 
            // FormXYTriggerLibraryManager
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(570, 332);
            this.Controls.Add(this.btnDisable);
            this.Controls.Add(this.btnEnable);
            this.Controls.Add(this.btnDown);
            this.Controls.Add(this.btnUp);
            this.Controls.Add(this.lbEnabled);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.lbDisabled);
            this.Controls.Add(this.label1);
            this.Name = "FormXYTriggerLibraryManager";
            this.Text = "咸鱼触发库管理器";
            this.Load += new System.EventHandler(this.FormXYTriggerLibraryManager_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListBox lbDisabled;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ListBox lbEnabled;
        private System.Windows.Forms.Button btnUp;
        private System.Windows.Forms.Button btnDown;
        private System.Windows.Forms.Button btnEnable;
        private System.Windows.Forms.Button btnDisable;
    }
}

