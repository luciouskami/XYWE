namespace XYMapCreator
{
    partial class FormXYMapCreator
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
            this.lbMapType = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btnKnowAuthor = new System.Windows.Forms.Button();
            this.btnMore = new System.Windows.Forms.Button();
            this.btnCreate = new System.Windows.Forms.Button();
            this.tbAuthor = new System.Windows.Forms.TextBox();
            this.tbVersion = new System.Windows.Forms.TextBox();
            this.tbDescription = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // lbMapType
            // 
            this.lbMapType.FormattingEnabled = true;
            this.lbMapType.ItemHeight = 12;
            this.lbMapType.Location = new System.Drawing.Point(12, 30);
            this.lbMapType.Name = "lbMapType";
            this.lbMapType.Size = new System.Drawing.Size(123, 220);
            this.lbMapType.TabIndex = 0;
            this.lbMapType.SelectedIndexChanged += new System.EventHandler(this.lbMapType_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(36, 10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(77, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "选择地图类型";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(141, 30);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(29, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "作者";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(141, 57);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(29, 12);
            this.label3.TabIndex = 3;
            this.label3.Text = "版本";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(141, 84);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(29, 12);
            this.label4.TabIndex = 4;
            this.label4.Text = "简介";
            // 
            // btnKnowAuthor
            // 
            this.btnKnowAuthor.Location = new System.Drawing.Point(403, 227);
            this.btnKnowAuthor.Name = "btnKnowAuthor";
            this.btnKnowAuthor.Size = new System.Drawing.Size(64, 23);
            this.btnKnowAuthor.TabIndex = 5;
            this.btnKnowAuthor.Text = "了解作者";
            this.btnKnowAuthor.UseVisualStyleBackColor = true;
            // 
            // btnMore
            // 
            this.btnMore.Location = new System.Drawing.Point(403, 198);
            this.btnMore.Name = "btnMore";
            this.btnMore.Size = new System.Drawing.Size(64, 23);
            this.btnMore.TabIndex = 6;
            this.btnMore.Text = "详细说明";
            this.btnMore.UseVisualStyleBackColor = true;
            // 
            // btnCreate
            // 
            this.btnCreate.Location = new System.Drawing.Point(176, 198);
            this.btnCreate.Name = "btnCreate";
            this.btnCreate.Size = new System.Drawing.Size(221, 52);
            this.btnCreate.TabIndex = 7;
            this.btnCreate.Text = "创建地图";
            this.btnCreate.UseVisualStyleBackColor = true;
            this.btnCreate.Click += new System.EventHandler(this.btnCreate_Click);
            // 
            // tbAuthor
            // 
            this.tbAuthor.Location = new System.Drawing.Point(176, 27);
            this.tbAuthor.Name = "tbAuthor";
            this.tbAuthor.Size = new System.Drawing.Size(291, 21);
            this.tbAuthor.TabIndex = 8;
            // 
            // tbVersion
            // 
            this.tbVersion.Location = new System.Drawing.Point(176, 54);
            this.tbVersion.Name = "tbVersion";
            this.tbVersion.Size = new System.Drawing.Size(291, 21);
            this.tbVersion.TabIndex = 9;
            // 
            // tbDescription
            // 
            this.tbDescription.Location = new System.Drawing.Point(176, 81);
            this.tbDescription.Multiline = true;
            this.tbDescription.Name = "tbDescription";
            this.tbDescription.Size = new System.Drawing.Size(291, 111);
            this.tbDescription.TabIndex = 10;
            // 
            // FormXYMapCreator
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(479, 262);
            this.Controls.Add(this.tbDescription);
            this.Controls.Add(this.tbVersion);
            this.Controls.Add(this.tbAuthor);
            this.Controls.Add(this.btnCreate);
            this.Controls.Add(this.btnMore);
            this.Controls.Add(this.btnKnowAuthor);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lbMapType);
            this.Name = "FormXYMapCreator";
            this.Text = "创建地图";
            this.Load += new System.EventHandler(this.FormXYMapCreator_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox lbMapType;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnKnowAuthor;
        private System.Windows.Forms.Button btnMore;
        private System.Windows.Forms.Button btnCreate;
        private System.Windows.Forms.TextBox tbAuthor;
        private System.Windows.Forms.TextBox tbVersion;
        private System.Windows.Forms.TextBox tbDescription;
    }
}

