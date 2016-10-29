namespace XYCodeLibraryManager {
    partial class FormXYCreateCodeLibrary {
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormXYCreateCodeLibrary));
            this.LCodeLibraryName = new System.Windows.Forms.Label();
            this.TbCodeLibraryName = new System.Windows.Forms.TextBox();
            this.BtnConfirm = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // LCodeLibraryName
            // 
            this.LCodeLibraryName.AutoSize = true;
            this.LCodeLibraryName.Location = new System.Drawing.Point(18, 10);
            this.LCodeLibraryName.Name = "LCodeLibraryName";
            this.LCodeLibraryName.Size = new System.Drawing.Size(233, 12);
            this.LCodeLibraryName.TabIndex = 0;
            this.LCodeLibraryName.Text = "仅可使用字母和数字，且首字符不能为数字";
            this.LCodeLibraryName.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // TbCodeLibraryName
            // 
            this.TbCodeLibraryName.Location = new System.Drawing.Point(12, 32);
            this.TbCodeLibraryName.Name = "TbCodeLibraryName";
            this.TbCodeLibraryName.Size = new System.Drawing.Size(244, 21);
            this.TbCodeLibraryName.TabIndex = 1;
            // 
            // BtnConfirm
            // 
            this.BtnConfirm.Location = new System.Drawing.Point(84, 62);
            this.BtnConfirm.Name = "BtnConfirm";
            this.BtnConfirm.Size = new System.Drawing.Size(98, 23);
            this.BtnConfirm.TabIndex = 2;
            this.BtnConfirm.Text = "确定";
            this.BtnConfirm.UseVisualStyleBackColor = true;
            this.BtnConfirm.Click += new System.EventHandler(this.BtnConfirm_Click);
            // 
            // FormXYCreateCodeLibrary
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(268, 93);
            this.Controls.Add(this.BtnConfirm);
            this.Controls.Add(this.TbCodeLibraryName);
            this.Controls.Add(this.LCodeLibraryName);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "FormXYCreateCodeLibrary";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "创建代码库";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label LCodeLibraryName;
        private System.Windows.Forms.TextBox TbCodeLibraryName;
        private System.Windows.Forms.Button BtnConfirm;
    }
}