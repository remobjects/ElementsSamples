package Sorter;

import System.Collections.Generic.*;
import System.Linq.*;
import System.Windows.*;
import System.Windows.Controls.*;
import System.Windows.Data.*;
import System.Windows.Documents.*;
import System.Windows.Media.*;
import System.Windows.Navigation.*;
import System.Windows.Shapes.*;
import System.Windows.Media.Animation.*;

public __partial class Window1
{
	public this()
	{
		InitializeComponent();
		FillGrid();
	}

	Rectangle[] fRectangles;
	Double[] fPositions;
	var fRandom = new Random();

	var fLoColor = { Colors.Blue, Colors.Green, Colors.Yellow, Colors.Pink, Colors.Coral, Colors.Cyan, Colors.Salmon };
	var fHiColor = { Colors.LightBlue, Colors.LightGreen, Colors.LightYellow, Colors.LightPink , Colors.LightCoral, Colors.LightCyan, Colors.LightSalmon };

	public void Randomize(Object sender, RoutedEventArgs e)
	{
		FillGrid();
	}

	public void Sort(Object sender, RoutedEventArgs e)
	{
		var lDelay = 0;
		Sort(0, fRectangles.Length - 1, /*__ref*/ lDelay);
	}

	private void FillGrid()
	{
		MainCanvas.Children.Clear();
		fRectangles = new Rectangle[](50);
		fPositions = new Double[](50);

		var lWidth = Width / 52.0;
		for (Integer i = 0; i < 50; i++)
		{
			var r = new Rectangle();
			r.HorizontalAlignment = HorizontalAlignment.Stretch;
			r.VerticalAlignment = VerticalAlignment.Bottom;
			r.Fill = new LinearGradientBrush(fLoColor[i % length(fLoColor)], fHiColor[i % length(fHiColor)], 20);
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

	private void Sort(Integer aLeft, Integer aRight, /*__ref*/ Integer aDelay)
	{
		while (aLeft < aRight)
		{
			var L = aLeft - 1;
			var R = aRight + 1;
			var Pivot = fRectangles[(aLeft + aRight) / 2].Height;

			while (true)
			{
				do {
					R -= 1;
				} while (fRectangles[R].Height > Pivot);

				do {
					L += 1;
				} while (fRectangles[L].Height < Pivot);

				if (L < R) {
					Switch(L, R, /*__ref*/ aDelay);
					aDelay = aDelay + 1;
				} else {
					break;
				}
			}

			if (aLeft < R) {
				Sort(aLeft, R, /*__ref*/ aDelay);
			}
			aLeft = R + 1;
		}
	}

	private void Switch(Integer aOne, Integer aTwo, /*__ref*/ Integer aDelay)
	{
		var lDuration = new Duration(new TimeSpan(0, 0, 0, 0, 200)); // 0.5 second
		var lStartDelay = new TimeSpan(0, 0, 0, aDelay / 4, (aDelay % 4) * 250); // 0.5 second

		var lAnim1 = new DoubleAnimation();
		lAnim1.Duration = lDuration;
		lAnim1.BeginTime = lStartDelay;
		lAnim1.To = fPositions[aTwo];

		var lAnim2 = new DoubleAnimation();
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