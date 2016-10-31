using Ini;

namespace XYBase
{
    class XYIni
    {
        static IniFile _Tips;
        public static IniFile Tips
        {
            get
            {
                if (_Tips == null)
                    _Tips = new IniFile(@"data\data.ini", nameof(Tips));
                return _Tips;
            }
        }

        static IniFile _Config;
        public static IniFile Config
        {
            get
            {
                if (_Config == null)
                    _Config = new IniFile(@"data\data.ini", nameof(Config));
                return _Config;
            }
        }
    }
}
