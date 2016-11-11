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

        /// <summary>
        /// 不可更改，已被Updater使用
        /// </summary>
        static IniFile _Cache;
        public static IniFile Cache
        {
            get
            {
                if (_Cache == null)
                    _Cache = new IniFile(XYPath.File.XyweDataIni, nameof(Cache));
                return _Cache;
            }
        }
    }
}
