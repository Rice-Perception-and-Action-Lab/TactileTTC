using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace TactorTest
{
    public partial class Form1 : Form
    {
        private int ConnectedDeviceID = -1;
        private static int MAX_GAIN = 255;
        private static double DISTANCE = 4.5;
        private static double SPEED = 3;
        private static double K = 50;
        private static double TTC = (DISTANCE / SPEED);
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
            /*int timeFactor = 10;
            Tdk.TdkInterface.RampGain(ConnectedDeviceID, 1, 10, 255, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.RampFreq(ConnectedDeviceID, 1, 300, 3500, 100 * timeFactor, Tdk.TdkDefines.RampLinear, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            Tdk.TdkInterface.Pulse(ConnectedDeviceID, 1, 100 * timeFactor, 0);
            */
            byte[] tactor_array = new byte[64]; //byte array of tactors
            tactor_array[0] = 1; //tactor 1 = on

            int step = 0;

            Tdk.TdkInterface.ChangeGain(ConnectedDeviceID, 0, 1, 0);
            Tdk.TdkInterface.SetTactors(ConnectedDeviceID, 0, tactor_array);
            
            Stopwatch timer = new Stopwatch(); //more accurate than date.time
            timer.Start();
            while (timer.Elapsed.TotalSeconds <= TTC)
            {
               double currentTime = timer.Elapsed.TotalSeconds; //get current time in seconds
               //if (currentTime % 1 == 0) //DEBUG: if seconds is evenly divisible
               //{
                    step = Convert.ToInt32(getNewGain(currentTime, DISTANCE, SPEED));
                    if (step <= (MAX_GAIN))
                    {
                        Console.WriteLine("value of time in method " + currentTime);
                        Console.WriteLine("value passed to gain " + step);
                        Tdk.TdkInterface.ChangeGain(ConnectedDeviceID, 1, step, 0);
                    }

               // }

            }
            timer.Stop();
            tactor_array[0] = 0; //tactor 2 = off
            Tdk.TdkInterface.SetTactors(ConnectedDeviceID, 0, tactor_array);

                
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

        static double getNewGain(double t, double r, double v)
        {
            //####
            //
            //getNewGain
            // @param double t: time value passed to determine the distance of the object along the looming curve
            // @param int d: value of distance passed
            // @param int s: value of speed passed
            // Follows the function for I = kr^-2 in Shaw, B. K., McGowan, R. S., & Turvey, M. T. (1991). An acoustic variable specifying time-to-contact. Ecological Psychology, 3(3), 253-261.
            // Where: k is constant; r is the distance of the object; and I = the intensity of the sound that follows an inverse square law related to distance of the object
            //
            //#####
            double r_traveled = (r - (v * t)); //break down the equation; calculate the amount the object has traveled
            double temp2 = 1 / (Math.Pow(r_traveled, 2)); //Math.pow returns 0 for number raised to neagtive power; so we instead do 1 / r^2
            double I = K * temp2; //Multiply by constant K
            if (I <= MAX_GAIN)
            {
                return I; //return value if less than or equal to max
            }
            else
            {
                return MAX_GAIN; //function is approaching infinity, return max value
            }
            
        }
    }
}
