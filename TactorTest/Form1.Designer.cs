namespace TactorTest
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.connectButton = new System.Windows.Forms.Button();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            this.fireTactor1 = new System.Windows.Forms.Button();
            this.fireTactor2 = new System.Windows.Forms.Button();
            this.rampTactor1 = new System.Windows.Forms.Button();
            this.rampTactor2 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // connectButton
            // 
            this.connectButton.AccessibleName = "connectButton";
            this.connectButton.Location = new System.Drawing.Point(49, 12);
            this.connectButton.Name = "connectButton";
            this.connectButton.Size = new System.Drawing.Size(136, 34);
            this.connectButton.TabIndex = 0;
            this.connectButton.Text = "Connect";
            this.connectButton.UseVisualStyleBackColor = true;
            this.connectButton.Click += new System.EventHandler(this.connectButton_Click);
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(12, 238);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(200, 115);
            this.richTextBox1.TabIndex = 1;
            this.richTextBox1.Text = "";
            // 
            // fireTactor1
            // 
            this.fireTactor1.Location = new System.Drawing.Point(49, 52);
            this.fireTactor1.Name = "fireTactor1";
            this.fireTactor1.Size = new System.Drawing.Size(136, 34);
            this.fireTactor1.TabIndex = 2;
            this.fireTactor1.Text = "Pulse Tactor 1";
            this.fireTactor1.UseVisualStyleBackColor = true;
            this.fireTactor1.Click += new System.EventHandler(this.fireTactor1_Click);
            // 
            // fireTactor2
            // 
            this.fireTactor2.Location = new System.Drawing.Point(49, 92);
            this.fireTactor2.Name = "fireTactor2";
            this.fireTactor2.Size = new System.Drawing.Size(136, 34);
            this.fireTactor2.TabIndex = 3;
            this.fireTactor2.Text = "Pulse Tactor 2";
            this.fireTactor2.UseVisualStyleBackColor = true;
            this.fireTactor2.Click += new System.EventHandler(this.fireTactor2_Click);
            // 
            // rampTactor1
            // 
            this.rampTactor1.Location = new System.Drawing.Point(49, 158);
            this.rampTactor1.Name = "rampTactor1";
            this.rampTactor1.Size = new System.Drawing.Size(136, 34);
            this.rampTactor1.TabIndex = 4;
            this.rampTactor1.Text = "Ramp Tactor 1";
            this.rampTactor1.UseVisualStyleBackColor = true;
            this.rampTactor1.Click += new System.EventHandler(this.rampTactor1_Click);
            // 
            // rampTactor2
            // 
            this.rampTactor2.Location = new System.Drawing.Point(49, 198);
            this.rampTactor2.Name = "rampTactor2";
            this.rampTactor2.Size = new System.Drawing.Size(136, 34);
            this.rampTactor2.TabIndex = 5;
            this.rampTactor2.Text = "Ramp Tactor 2";
            this.rampTactor2.UseVisualStyleBackColor = true;
            this.rampTactor2.Click += new System.EventHandler(this.rampTactor2_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(225, 375);
            this.Controls.Add(this.rampTactor2);
            this.Controls.Add(this.rampTactor1);
            this.Controls.Add(this.fireTactor2);
            this.Controls.Add(this.fireTactor1);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.connectButton);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button connectButton;
        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.Button fireTactor1;
        private System.Windows.Forms.Button fireTactor2;
        private System.Windows.Forms.Button rampTactor1;
        private System.Windows.Forms.Button rampTactor2;
    }
}

