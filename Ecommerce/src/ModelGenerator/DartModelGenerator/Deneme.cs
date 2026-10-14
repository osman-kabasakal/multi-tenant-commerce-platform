namespace DartModelGenerator;

public class Deneme
{
    public string Type1 { get; set; }
    public string Type2 { get; set; }
    public string Type3 { get; set; }
    
    //Nested class
    public class SharedNameClass
    {
        public string SharedNameNestedClassType1 { get; set; }
        public string SharedNameNestedClassType2 { get; set; }
    }
}

public class SharedNameClass
{
    public string SharedNameClassType1 { get; set; }
    public string SharedNameClassType2 { get; set; }
}