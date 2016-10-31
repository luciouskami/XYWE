// http://www.codeproject.com/Articles/1966/An-INI-file-handling-class-using-C

using System.Runtime.InteropServices;
using System.Text;

namespace Ini
{
    /// <summary>
    /// Create a New INI file to store or load data
    /// </summary>
    public class IniFile
    {
        public string this[string section, string key]
        {
            get
            {
                return ReadValue(section, key);
            }
            set
            {
                WriteValue(section, key, value);
            }
        }
        public string this[string key]
        {
            get
            {
                return this[section, key];
            }
            set
            {
                this[section, key] = value;
            }
        }

        string section;
        string path;

        [DllImport("kernel32")]
        static extern long WritePrivateProfileString(string section, string key, string val, string filePath);
        [DllImport("kernel32")]
        static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);

        /// <summary>
        /// INIFile Constructor.
        /// </summary>
        /// <PARAM name="iniPath"></PARAM>
        public IniFile(string iniPath, string section = "")
        {
            path = iniPath;
            this.section = section;
        }

        /// <summary>
        /// Set Current Selected Section
        /// </summary>
        /// <param name="section"></param>
        public void SetSection(string section)
        {
            this.section = section;
        }

        /// <summary>
        /// Write Data to the INI File
        /// </summary>
        /// <PARAM name="Section"></PARAM>
        /// Section name
        /// <PARAM name="Key"></PARAM>
        /// Key Name
        /// <PARAM name="Value"></PARAM>
        /// Value Name
        void WriteValue(string Section, string Key, string Value)
        {
            WritePrivateProfileString(Section, Key, Value, this.path);
        }

        /// <summary>
        /// Read Data Value From the Ini File
        /// </summary>
        /// <PARAM name="Section"></PARAM>
        /// <PARAM name="Key"></PARAM>
        /// <PARAM name="Path"></PARAM>
        /// <returns></returns>
        string ReadValue(string Section, string Key)
        {
            StringBuilder temp = new StringBuilder(255);
            int i = GetPrivateProfileString(Section, Key, "", temp, 255, this.path);
            return temp.ToString();
        }
    }
}
