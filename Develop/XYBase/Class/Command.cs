class Command
{
    public string source;
    public string name;
    public string param;
    string[] _paramGroup;
    public string[] paramGroup
    {
        get
        {
            if (_paramGroup == null) _paramGroup = param.Split(',');
            return _paramGroup;
        }
    }
    public Command(string source)
    {
        this.source = source;
        if (this.source.Contains(":"))
        {
            var split = source.Split(new[] { ':' }, 2);
            this.name = split[0].Replace("[[@", "");
            this.param = split[1].Replace("]]", "");
        }
        else
        {
            this.name = source.Replace("[[@", "").Replace("]]", "");
        }
    }
}