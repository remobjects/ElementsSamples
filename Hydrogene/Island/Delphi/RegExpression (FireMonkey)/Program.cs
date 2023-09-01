using System.StartUpCopy;
using FMX.Forms;

namespace RegExpression
{
    public static class Program
    {

        public int Main(string[] args)
        {
            Application.Initialize();
            Application.CreateForm(TForm1, ref Form1);
            Application.Run();
        }
    }
}