﻿namespace XYWE {
    partial class FormXYWE {
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormXYWE));
            this.LlVersion = new System.Windows.Forms.LinkLabel();
            this.BtnXYCodeLibraryManager = new System.Windows.Forms.Button();
            this.BtnXYUILibraryManager = new System.Windows.Forms.Button();
            this.BtnStartXYWE = new System.Windows.Forms.Button();
            this.BtnXYTextColorMaker = new System.Windows.Forms.Button();
            this.BtnXYTriggerSyntaxHighlighter = new System.Windows.Forms.Button();
            this.linkLabel1 = new System.Windows.Forms.LinkLabel();
            this.cbUI = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.btnPatchUI = new System.Windows.Forms.Button();
            this.btnLibrary = new System.Windows.Forms.Button();
            this.btnCreateMap = new System.Windows.Forms.Button();
            this.cbEnableRSJBWETextEditor16_0 = new System.Windows.Forms.CheckBox();
            this.btnConfigRSJBWETextEditor15_0 = new System.Windows.Forms.Button();
            this.BtnOnlineRoomA = new System.Windows.Forms.Button();
            this.BtnOnlineRoomB = new System.Windows.Forms.Button();
            this.LbOnline = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // LlVersion
            // 
            this.LlVersion.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.LlVersion.Location = new System.Drawing.Point(95, 135);
            this.LlVersion.Name = "LlVersion";
            this.LlVersion.Size = new System.Drawing.Size(241, 12);
            this.LlVersion.TabIndex = 0;
            this.LlVersion.TabStop = true;
            this.LlVersion.Text = "LlVersion";
            this.LlVersion.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.LlVersion.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.LlVersion_LinkClicked);
            // 
            // BtnXYCodeLibraryManager
            // 
            this.BtnXYCodeLibraryManager.Font = new System.Drawing.Font("宋体", 9F);
            this.BtnXYCodeLibraryManager.Location = new System.Drawing.Point(30, 3);
            this.BtnXYCodeLibraryManager.Name = "BtnXYCodeLibraryManager";
            this.BtnXYCodeLibraryManager.Size = new System.Drawing.Size(10, 10);
            this.BtnXYCodeLibraryManager.TabIndex = 1;
            this.BtnXYCodeLibraryManager.Text = "代码库管理器";
            this.BtnXYCodeLibraryManager.UseVisualStyleBackColor = true;
            this.BtnXYCodeLibraryManager.Visible = false;
            this.BtnXYCodeLibraryManager.Click += new System.EventHandler(this.BtnXYCodeLibraryManager_Click);
            // 
            // BtnXYUILibraryManager
            // 
            this.BtnXYUILibraryManager.Font = new System.Drawing.Font("宋体", 9F);
            this.BtnXYUILibraryManager.Location = new System.Drawing.Point(46, 3);
            this.BtnXYUILibraryManager.Name = "BtnXYUILibraryManager";
            this.BtnXYUILibraryManager.Size = new System.Drawing.Size(10, 10);
            this.BtnXYUILibraryManager.TabIndex = 3;
            this.BtnXYUILibraryManager.Text = "UI库管理器";
            this.BtnXYUILibraryManager.UseVisualStyleBackColor = true;
            this.BtnXYUILibraryManager.Visible = false;
            this.BtnXYUILibraryManager.Click += new System.EventHandler(this.BtnXYUILibraryManager_Click);
            // 
            // BtnStartXYWE
            // 
            this.BtnStartXYWE.Location = new System.Drawing.Point(95, 60);
            this.BtnStartXYWE.Name = "BtnStartXYWE";
            this.BtnStartXYWE.Size = new System.Drawing.Size(161, 51);
            this.BtnStartXYWE.TabIndex = 4;
            this.BtnStartXYWE.Text = "启动咸鱼地图编辑器";
            this.BtnStartXYWE.UseVisualStyleBackColor = true;
            this.BtnStartXYWE.Click += new System.EventHandler(this.BtnStartXYWE_Click);
            // 
            // BtnXYTextColorMaker
            // 
            this.BtnXYTextColorMaker.Font = new System.Drawing.Font("宋体", 9F);
            this.BtnXYTextColorMaker.Location = new System.Drawing.Point(14, 3);
            this.BtnXYTextColorMaker.Name = "BtnXYTextColorMaker";
            this.BtnXYTextColorMaker.Size = new System.Drawing.Size(10, 10);
            this.BtnXYTextColorMaker.TabIndex = 5;
            this.BtnXYTextColorMaker.Text = "文本染色器";
            this.BtnXYTextColorMaker.UseVisualStyleBackColor = true;
            this.BtnXYTextColorMaker.Visible = false;
            this.BtnXYTextColorMaker.Click += new System.EventHandler(this.BtnXYTextColorMaker_Click);
            // 
            // BtnXYTriggerSyntaxHighlighter
            // 
            this.BtnXYTriggerSyntaxHighlighter.Location = new System.Drawing.Point(12, 60);
            this.BtnXYTriggerSyntaxHighlighter.Name = "BtnXYTriggerSyntaxHighlighter";
            this.BtnXYTriggerSyntaxHighlighter.Size = new System.Drawing.Size(77, 51);
            this.BtnXYTriggerSyntaxHighlighter.TabIndex = 6;
            this.BtnXYTriggerSyntaxHighlighter.Text = "触发器脚本\r\n配色修改器";
            this.BtnXYTriggerSyntaxHighlighter.UseVisualStyleBackColor = true;
            this.BtnXYTriggerSyntaxHighlighter.Click += new System.EventHandler(this.BtnXYTriggerSyntaxHighlighter_Click);
            // 
            // linkLabel1
            // 
            this.linkLabel1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.linkLabel1.Location = new System.Drawing.Point(12, 135);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new System.Drawing.Size(56, 12);
            this.linkLabel1.TabIndex = 7;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "反馈BUG";
            this.linkLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.linkLabel1.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel1_LinkClicked);
            // 
            // cbUI
            // 
            this.cbUI.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbUI.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.cbUI.FormattingEnabled = true;
            this.cbUI.Items.AddRange(new object[] {
            "XYWE",
            "YDWE"});
            this.cbUI.Location = new System.Drawing.Point(83, 13);
            this.cbUI.Name = "cbUI";
            this.cbUI.Size = new System.Drawing.Size(173, 20);
            this.cbUI.TabIndex = 8;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 12);
            this.label1.TabIndex = 9;
            this.label1.Text = "标准UI方案";
            // 
            // btnPatchUI
            // 
            this.btnPatchUI.Location = new System.Drawing.Point(262, 12);
            this.btnPatchUI.Name = "btnPatchUI";
            this.btnPatchUI.Size = new System.Drawing.Size(74, 22);
            this.btnPatchUI.TabIndex = 10;
            this.btnPatchUI.Text = "应用";
            this.btnPatchUI.UseVisualStyleBackColor = true;
            this.btnPatchUI.Click += new System.EventHandler(this.btnPatchUI_Click);
            // 
            // btnLibrary
            // 
            this.btnLibrary.Font = new System.Drawing.Font("宋体", 9F);
            this.btnLibrary.Location = new System.Drawing.Point(2, 3);
            this.btnLibrary.Name = "btnLibrary";
            this.btnLibrary.Size = new System.Drawing.Size(10, 10);
            this.btnLibrary.TabIndex = 11;
            this.btnLibrary.Text = "函数库管理器";
            this.btnLibrary.UseVisualStyleBackColor = true;
            this.btnLibrary.Visible = false;
            this.btnLibrary.Click += new System.EventHandler(this.btnLibrary_Click);
            // 
            // btnCreateMap
            // 
            this.btnCreateMap.Enabled = false;
            this.btnCreateMap.Location = new System.Drawing.Point(62, 3);
            this.btnCreateMap.Name = "btnCreateMap";
            this.btnCreateMap.Size = new System.Drawing.Size(10, 10);
            this.btnCreateMap.TabIndex = 12;
            this.btnCreateMap.Text = "创建新地图";
            this.btnCreateMap.UseVisualStyleBackColor = true;
            this.btnCreateMap.Visible = false;
            this.btnCreateMap.Click += new System.EventHandler(this.btnCreateMap_Click);
            // 
            // cbEnableRSJBWETextEditor16_0
            // 
            this.cbEnableRSJBWETextEditor16_0.AutoSize = true;
            this.cbEnableRSJBWETextEditor16_0.Location = new System.Drawing.Point(14, 39);
            this.cbEnableRSJBWETextEditor16_0.Name = "cbEnableRSJBWETextEditor16_0";
            this.cbEnableRSJBWETextEditor16_0.Size = new System.Drawing.Size(192, 16);
            this.cbEnableRSJBWETextEditor16_0.TabIndex = 13;
            this.cbEnableRSJBWETextEditor16_0.Text = "启用人生脚步WE文本修改器16.0";
            this.cbEnableRSJBWETextEditor16_0.UseVisualStyleBackColor = true;
            this.cbEnableRSJBWETextEditor16_0.CheckedChanged += new System.EventHandler(this.cbEnableRSJBWETextEditor16_0_CheckedChanged);
            // 
            // btnConfigRSJBWETextEditor15_0
            // 
            this.btnConfigRSJBWETextEditor15_0.Location = new System.Drawing.Point(204, 36);
            this.btnConfigRSJBWETextEditor15_0.Name = "btnConfigRSJBWETextEditor15_0";
            this.btnConfigRSJBWETextEditor15_0.Size = new System.Drawing.Size(44, 20);
            this.btnConfigRSJBWETextEditor15_0.TabIndex = 14;
            this.btnConfigRSJBWETextEditor15_0.Text = "配置";
            this.btnConfigRSJBWETextEditor15_0.UseVisualStyleBackColor = true;
            this.btnConfigRSJBWETextEditor15_0.Click += new System.EventHandler(this.btnConfigRSJBWETextEditor15_0_Click);
            // 
            // BtnOnlineRoomA
            // 
            this.BtnOnlineRoomA.Location = new System.Drawing.Point(262, 60);
            this.BtnOnlineRoomA.Name = "BtnOnlineRoomA";
            this.BtnOnlineRoomA.Size = new System.Drawing.Size(74, 25);
            this.BtnOnlineRoomA.TabIndex = 16;
            this.BtnOnlineRoomA.Text = "在线交流A";
            this.BtnOnlineRoomA.UseVisualStyleBackColor = true;
            this.BtnOnlineRoomA.Click += new System.EventHandler(this.BtnOnlineRoomA_Click);
            // 
            // BtnOnlineRoomB
            // 
            this.BtnOnlineRoomB.Location = new System.Drawing.Point(262, 86);
            this.BtnOnlineRoomB.Name = "BtnOnlineRoomB";
            this.BtnOnlineRoomB.Size = new System.Drawing.Size(74, 25);
            this.BtnOnlineRoomB.TabIndex = 17;
            this.BtnOnlineRoomB.Text = "在线交流B";
            this.BtnOnlineRoomB.UseVisualStyleBackColor = true;
            this.BtnOnlineRoomB.Click += new System.EventHandler(this.BtnOnlineRoomB_Click);
            // 
            // LbOnline
            // 
            this.LbOnline.Location = new System.Drawing.Point(114, 117);
            this.LbOnline.Name = "LbOnline";
            this.LbOnline.Size = new System.Drawing.Size(222, 12);
            this.LbOnline.TabIndex = 18;
            this.LbOnline.Text = "当前在线:? / 今日已上线:?";
            this.LbOnline.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // FormXYWE
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(348, 154);
            this.Controls.Add(this.LbOnline);
            this.Controls.Add(this.BtnOnlineRoomB);
            this.Controls.Add(this.BtnOnlineRoomA);
            this.Controls.Add(this.btnConfigRSJBWETextEditor15_0);
            this.Controls.Add(this.cbEnableRSJBWETextEditor16_0);
            this.Controls.Add(this.btnCreateMap);
            this.Controls.Add(this.btnLibrary);
            this.Controls.Add(this.btnPatchUI);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cbUI);
            this.Controls.Add(this.linkLabel1);
            this.Controls.Add(this.BtnXYTriggerSyntaxHighlighter);
            this.Controls.Add(this.BtnXYTextColorMaker);
            this.Controls.Add(this.BtnStartXYWE);
            this.Controls.Add(this.BtnXYUILibraryManager);
            this.Controls.Add(this.BtnXYCodeLibraryManager);
            this.Controls.Add(this.LlVersion);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "FormXYWE";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "咸鱼地图编辑器";
            this.Load += new System.EventHandler(this.FormXYWE_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.LinkLabel LlVersion;
        private System.Windows.Forms.Button BtnXYCodeLibraryManager;
        private System.Windows.Forms.Button BtnXYUILibraryManager;
        private System.Windows.Forms.Button BtnStartXYWE;
        private System.Windows.Forms.Button BtnXYTextColorMaker;
        private System.Windows.Forms.Button BtnXYTriggerSyntaxHighlighter;
        private System.Windows.Forms.LinkLabel linkLabel1;
        private System.Windows.Forms.ComboBox cbUI;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnPatchUI;
        private System.Windows.Forms.Button btnLibrary;
        private System.Windows.Forms.Button btnCreateMap;
        private System.Windows.Forms.CheckBox cbEnableRSJBWETextEditor16_0;
        private System.Windows.Forms.Button btnConfigRSJBWETextEditor15_0;
        private System.Windows.Forms.Button BtnOnlineRoomA;
        private System.Windows.Forms.Button BtnOnlineRoomB;
        private System.Windows.Forms.Label LbOnline;
    }
}

