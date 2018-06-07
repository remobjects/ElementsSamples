import System.Collections.Generic
import System.Linq
import System.Windows
import System.Windows.Controls
import System.Windows.Data
import System.Windows.Documents
import System.Windows.Media
import System.Windows.Navigation
import System.Windows.Shapes
import System.Windows.Media.Animation

public class Window1 {

	public init() {
		InitializeComponent();
		FillGrid();
	}

	var fRectangles: Rectangle[]!
	var fPositions: Double[]!
	let fRandom = Random()

	let fLoColor = [Colors.Blue, Colors.Green, Colors.Yellow, Colors.Pink, Colors.Coral, Colors.Cyan, Colors.Salmon]
	let fHiColor = [Colors.LightBlue, Colors.LightGreen, Colors.LightYellow, Colors.LightPink , Colors.LightCoral, Colors.LightCyan, Colors.LightSalmon]

	func Randomize(_ sender: System.Object!, _ e: System.Windows.RoutedEventArgs!) {
		FillGrid();
	}

	func Sort(_ sender: System.Object!, _ e: System.Windows.RoutedEventArgs!) {
		var lDelay = 0;
		Sort(0, fRectangles.Length - 1, &lDelay);
	}

	private func FillGrid() {
		MainCanvas.Children.Clear();
		fRectangles = Rectangle[](50);
		fPositions = Double[](50);

		var lWidth = Width / 52.0;
		for i in 0 ..< 50 {
			var r = Rectangle();
			r.HorizontalAlignment = HorizontalAlignment.Stretch;
			r.VerticalAlignment = VerticalAlignment.Bottom;
			r.Fill = LinearGradientBrush(fLoColor[i % count(fLoColor)], fHiColor[i % count(fHiColor)], 20);
			r.Height = fRandom.NextDouble() * (Height - 80) + 10;
			r.Width = lWidth;
			Canvas.SetLeft(r, i * r.Width);
			Canvas.SetTop(r, -r.Height);
			r.Opacity = 0.75;
			Grid.SetColumn(r, i);

			fRectangles[i] = r;
			fPositions[i] = i * r.Width;

			MainCanvas.Children.Add(r);
		}
	}

	private func Sort(_ aLeft: Integer, _ aRight: Integer, inout _ aDelay: Int) {
		var aLeft = aLeft;
		while aLeft < aRight {
			var L = aLeft - 1;
			var R = aRight + 1;
			var Pivot = fRectangles[(aLeft + aRight) / 2].Height;

			while true {
				repeat {
					R -= 1;
				} while fRectangles[R].Height > Pivot;

				repeat {
					L += 1;
				} while fRectangles[L].Height < Pivot;

				if L < R {
					Switch(L, R, aDelay);
					aDelay = aDelay + 1;
				} else {
					break;
				}
			}

			if aLeft < R {
				Sort(aLeft, R, &aDelay);
			}
			aLeft = R + 1;
		}
	}

	private func Switch(_ aOne: Integer, _ aTwo: Integer, _ aDelay: Integer) {
		var lDuration = Duration(TimeSpan(0, 0, 0, 0, 200)) // 0.5 second
		var lStartDelay = TimeSpan(0, 0, 0, aDelay / 4, (aDelay % 4) * 250); // 0.5 second

		var lAnim1 = DoubleAnimation();
		lAnim1.Duration = lDuration;
		lAnim1.BeginTime = lStartDelay;
		lAnim1.To = fPositions[aTwo];

		var lAnim2 = DoubleAnimation();
		lAnim2.Duration = lDuration;
		lAnim2.BeginTime = lStartDelay;
		lAnim2.To = fPositions[aOne];

		fRectangles[aOne].BeginAnimation(Canvas.LeftProperty, lAnim1, HandoffBehavior.Compose);
		fRectangles[aTwo].BeginAnimation(Canvas.LeftProperty, lAnim2, HandoffBehavior.Compose);

		var r = fRectangles[aOne];
		fRectangles[aOne] = fRectangles[aTwo];
		fRectangles[aTwo] = r;
	}
}