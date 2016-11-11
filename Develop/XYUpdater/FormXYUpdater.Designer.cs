namespace XYUpdater
{
    partial class FormXYUpdater
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
            this.tbLog = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lbVersion = new System.Windows.Forms.ListBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btnDoSwitch = new System.Windows.Forms.Button();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.button2 = new System.Windows.Forms.Button();
            this.tbHint = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // tbLog
            // 
            this.tbLog.BackColor = System.Drawing.SystemColors.Window;
            this.tbLog.Location = new System.Drawing.Point(178, 37);
            this.tbLog.Multiline = true;
            this.tbLog.Name = "tbLog";
            this.tbLog.ReadOnly = true;
            this.tbLog.Size = new System.Drawing.Size(518, 231);
            this.tbLog.TabIndex = 0;
            this.tbLog.TabStop = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(410, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "更新日志";
            // 
            // lbVersion
            // 
            this.lbVersion.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lbVersion.FormattingEnabled = true;
            this.lbVersion.ItemHeight = 12;
            this.lbVersion.Location = new System.Drawing.Point(12, 37);
            this.lbVersion.Name = "lbVersion";
            this.lbVersion.Size = new System.Drawing.Size(160, 422);
            this.lbVersion.TabIndex = 2;
            this.lbVersion.TabStop = false;
            this.lbVersion.SelectedIndexChanged += new System.EventHandler(this.lbVersion_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(64, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "历史版本";
            // 
            // btnDoSwitch
            // 
            this.btnDoSwitch.Location = new System.Drawing.Point(178, 407);
            this.btnDoSwitch.Name = "btnDoSwitch";
            this.btnDoSwitch.Size = new System.Drawing.Size(140, 54);
            this.btnDoSwitch.TabIndex = 4;
            this.btnDoSwitch.Text = "切换到所选版本";
            this.btnDoSwitch.UseVisualStyleBackColor = true;
            this.btnDoSwitch.Click += new System.EventHandler(this.btnDoSwitch_Click);
            // 
            // textBox2
            // 
            this.textBox2.BackColor = System.Drawing.SystemColors.Window;
            this.textBox2.Location = new System.Drawing.Point(178, 307);
            this.textBox2.Multiline = true;
            this.textBox2.Name = "textBox2";
            this.textBox2.ReadOnly = true;
            this.textBox2.Size = new System.Drawing.Size(518, 94);
            this.textBox2.TabIndex = 5;
            this.textBox2.TabStop = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(370, 281);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(137, 12);
            this.label3.TabIndex = 6;
            this.label3.Text = "会被修改的本地文件列表";
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(324, 407);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(140, 54);
            this.button2.TabIndex = 7;
            this.button2.Text = "查看版本详细资料";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // tbHint
            // 
            this.tbHint.BackColor = System.Drawing.SystemColors.Control;
            this.tbHint.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tbHint.Location = new System.Drawing.Point(470, 407);
            this.tbHint.Multiline = true;
            this.tbHint.Name = "tbHint";
            this.tbHint.ReadOnly = true;
            this.tbHint.Size = new System.Drawing.Size(226, 52);
            this.tbHint.TabIndex = 9;
            this.tbHint.TabStop = false;
            // 
            // FormXYUpdater
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(708, 475);
            this.Controls.Add(this.tbHint);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.btnDoSwitch);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.lbVersion);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tbLog);
            this.Name = "FormXYUpdater";
            this.Text = "咸鱼更新器";
            this.Load += new System.EventHandler(this.FormXYUpdater_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tbLog;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListBox lbVersion;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnDoSwitch;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.TextBox tbHint;
    }
}

