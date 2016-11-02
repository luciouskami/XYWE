class Command
{
    public string source;
    public string name;
    public string param;
    public Command(string source)
    {
        this.source = source;
        if (this.source.Contains(":"))
        {
            var split = source.Split(':');
            this.name = split[0].Replace("[[@", "");
            this.param = split[1].Replace("]]", "");
        }
        else
        {
            this.name = source.Replace("[[@", "").Replace("]]", "");
        }
    }
}