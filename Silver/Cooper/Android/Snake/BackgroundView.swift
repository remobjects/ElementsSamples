/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Translated to Swift by marc hoffman, RemObjects Software.
 *
 */

import android.content
import android.content.res
import android.graphics
import android.util
import android.view

import java.util

// Background View: Draw 4 full-screen RGBY triangles
public class BackgroundView : View {

	var _colors: Int[] = [0,0,0,0] // [4]

	let _indices: SmallInt[] = [0, 1, 2, 0, 3, 4, 0, 1, 4] // Corner points for triangles (with offset = 2)

	var _vertexPoints: Float[]!

	public init(_ context: Context, _ attrs: AttributeSet) {
		super.init(context, attrs)
		setFocusable(true)

		// retrieve colors for 4 segments from styleable properties
		let a = context.obtainStyledAttributes(attrs, R.styleable.BackgroundView)
		_colors[0] = a.getColor(R.styleable.BackgroundView_colorSegmentOne, Color.RED)
		_colors[1] = a.getColor(R.styleable.BackgroundView_colorSegmentTwo, Color.YELLOW)
		_colors[2] = a.getColor(R.styleable.BackgroundView_colorSegmentThree, Color.BLUE)
		_colors[3] = a.getColor(R.styleable.BackgroundView_colorSegmentFour, Color.GREEN)

		a.recycle()
	}

	public override func onDraw(_ canvas: Canvas!) {
		assert(_vertexPoints != nil)

		// Colors for each vertex
		var fillColors = Int32[]!(_vertexPoints.length);

		for triangle in 0 ..< _colors.length {
			// Set color for all vertex points to current triangle color
			Arrays.fill(fillColors, _colors[triangle])

			// Draw one triangle
			canvas.drawVertices(Canvas.VertexMode.TRIANGLES, _vertexPoints.length, _vertexPoints,
					0, nil, 0, // No Textures
					fillColors, 0, _indices,
					triangle * 2, 3, // Use 3 vertices via Index Array with offset 2
					Paint())
		}
	}

	public override func onSizeChanged(_ w: Int32, _ h: Int32, _ oldw: Int32, _ oldh: Int32) {
		super.onSizeChanged(w, h, oldw, oldh)

		// Construct our center and four corners
		_vertexPoints = [
				w / 2, h / 2,
				0, 0,
				w, 0,
				w, h,
				0, h
		]
	}

}
