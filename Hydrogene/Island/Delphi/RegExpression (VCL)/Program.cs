using VCL.Forms;

namespace RegExpression
{

    public class Program
    {
        public static void Main(string[] args)
        {
            Application.Initialize();
            Application.MainFormOnTaskBar = true;
            Application.CreateForm(TForm1, ref Form1);
            Application.Run();
        }
    }
}