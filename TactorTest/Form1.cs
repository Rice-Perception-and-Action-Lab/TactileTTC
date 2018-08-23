using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TactorTest
{
    public partial class Form1 : Form
    {
        private int ConnectedDeviceID = -1;

        public Form1()
        {
            InitializeComponent();
            Tdk.TdkInterface.InitializeTI();


            fireTactor1.Enabled = false;
            fireTactor2.Enabled = false;
            rampTactor1.Enabled = false;
            rampTactor2.Enabled = false;
        }
        
        private void connectButton_Click(object sender, EventArgs e)
        {
            string selectedComPort = "COM4";
            WriteMessageToGUIConsole("Connecting to com port " + selectedComPort + "\n");
            int ret = Tdk.TdkInterface.Connect(selectedComPort,
                                               (int)Tdk.TdkDefines.DeviceTypes.Serial,
                                                System.IntPtr.Zero);

            if (ret >= 0)
            {
                WriteMessageToGUIConsole("Connected to control unit!\n");
                ConnectedDeviceID = ret;
                connectButton.Enabled = false;
                fireTactor1.Enabled = true;
                fireTactor2.Enabled = true;
                rampTactor1.Enabled = true;
                rampTactor2.Enabled = true;

            }
            else
            {
                WriteMessageToGUIConsole(Tdk.TdkDefines.GetLastEAIErrorString());
            }
        }
    
        private void WriteMessageToGUIConsole(string msg)
        {
            
            richTextBox1.AppendText(msg);
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            CheckTDKErrors(Tdk.TdkInterface.Close(ConnectedDeviceID));
            CheckTDKErrors(Tdk.TdkInterface.ShutdownTI());
        }

        private void CheckTDKErrors(int ret)
        {
            if (ret < 0)
            {
                WriteMessageToGUIConsole(Tdk.TdkDefines.GetLastEAIErrorString());
            }
        }

        private void fireTactor1_Click(object sender, EventArgs e)
        {
            WriteMessageToGUIConsole("Pulse tactor 1\n");
            CheckTDKErrors(Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 250, 0));
        }

        private void fireTactor2_Click(object sender, EventArgs e)
        {
            WriteMessageToGUIConsole("Pulse tactor 2\n");
            CheckTDKErrors(Tdk.TdkInterface.Pulse(ConnectedDeviceID, 2, 250, 0));
        }

        private void rampTactor1_Click(object sender, EventArgs e)
        {
            int timeFactor = 10;
            Tdk.TdkInterface.RampGain(ConnectedDeviceID, 1, 10, 255, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.RampFreq(ConnectedDeviceID, 1, 300, 3500, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);

        }

        private void rampTactor2_Click(object sender, EventArgs e)
        {
            int timeFactor = 10;
            Tdk.TdkInterface.RampGain(ConnectedDeviceID, 2, 10, 255, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.RampFreq(ConnectedDeviceID, 2, 300, 3500, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 2, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 2, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 2, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 2, 100 * timeFactor, 0);

        }
    }
}
