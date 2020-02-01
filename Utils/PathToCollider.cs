using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

class Program
{
  static int Main(string[] args)
  {
    string infile = args[0];
    string outfile = args.Length > 1 ? args[1] : Path.ChangeExtension(args[0], ".collider.lua");

    var ser = new XmlSerializer(typeof(SvgRoot));
    using (var stream = File.Open(infile, FileMode.Open, FileAccess.Read))
    {
      using (var outstream = new StreamWriter(outfile, false, Encoding.UTF8))
      {
        var svg = (SvgRoot)ser.Deserialize(stream);
        var code = svg.Path.Code;
        var startOf = code.IndexOf("C ");
        code = code.Substring(startOf + 2);
        var lines = code
          .Split(' ')
          .Select(i => i.Trim())
          .Where(i => i.Length > 0);

        outstream.WriteLine("verts = {");

        var c = 0;
        string last = null;
        foreach (var l in lines)
        {
          if (l != last)
          {
            outstream.WriteLine("\t{0},", l);
            c++;
          }
          last = l;
        }
        outstream.WriteLine("}");

        if (c > 8)
        {
          Console.WriteLine("Too many nodes, press enter");
          Console.ReadLine();
        }
      }
    }

    return 0;
  }
}

[XmlRoot("svg", Namespace = "http://www.w3.org/2000/svg")]
public class SvgRoot
{
  [XmlElement("path")]
  public SvgPath Path { get; set; }
}

public class SvgPath
{
  [XmlAttribute("d")]
  public string Code { get; set; }
}