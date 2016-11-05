using Ini;

namespace XYBase
{
    /// <summary>
    /// 仅用于在XYBase内使用，每一个成员对应的是一个Section。
    /// 使用时仅需填写key，不用填写section。
    /// </summary>
    class XYIni
    {
        static IniFile _Tips;
        public static IniFile Tips
        {
            get
            {
                if (_Tips == null)
                    _Tips = new IniFile(XYPath.File.XyweDataIni, nameof(Tips));
                return _Tips;
            }
        }

        static IniFile _Config;
        public static IniFile Config
        {
            get
            {
                if (_Config == null)
                    _Config = new IniFile(XYPath.File.XyweDataIni, nameof(Config));
                return _Config;
            }
        }

        static IniFile _Package;
        public static IniFile Package
        {
            get
            {
                if (_Package == null)
                    _Package = new IniFile(XYPath.File.XyweDataIni, nameof(Package));
                return _Package;
            }
        }
    }
}
