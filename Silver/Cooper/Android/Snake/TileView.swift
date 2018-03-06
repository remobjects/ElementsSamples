/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
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
import android.graphics.drawable
import android.util
import android.view

/**
 * TileView: a View-variant designed for handling arrays of "icons" or other drawables.
 **/
public class TileView : View {

	/**
	 * Parameters controlling the size of the tiles and their range within view. Width/Height are in
	 * pixels, and Drawables will be scaled to fit to these dimensions. X/Y Tile Counts are the
	 * number of tiles that will be drawn.
	 **/

	class var _tileSize: Int?

	class var XTileCount: Int!
	class var YTileCount: Int!

	class var _XOffset: Int?
	class var _YOffset: Int?

	let _paint = Paint()

	// A hash that maps integer handles specified by the subclasser to the drawable that will be used for that reference
	var _tileArray : Bitmap[]!

	// A two-dimensional array of integers in which the number represents the index of the tile that
	var _tileGrid: Star[][]!

	public init(_ context: Context, _ attrs: AttributeSet) {
		super. init(context, attrs)

		let a = context.obtainStyledAttributes(attrs, R.styleable.TileView)
		_tileSize = a.getDimensionPixelSize(R.styleable.TileView_tileSize, 12)

		a.recycle()
	}

	public init(_ context: Context, _ attrs: AttributeSet, _ defStyle: Int) {
		super.init(context, attrs, defStyle)

		let a = context.obtainStyledAttributes(attrs, R.styleable.TileView)
		_tileSize = a.getDimensionPixelSize(R.styleable.TileView_tileSize, 12)

		a.recycle()
	}

	// Resets all tiles to 0 (empty)
	func clearTiles() {
		for x in 0 ..< XTileCount {
			for y in 0 ..< YTileCount {
				setTile(.NONE, x: x, y: y)
			}
		}
	}

	/**
	 * Function to set the specified Drawable as the tile for a particular integer key.
	 *
	 * @param key
	 * @param tile
	 */
	func loadTile(tile: Drawable, key: Star) {
		let bitmap = Bitmap.createBitmap(_tileSize!, _tileSize!, Bitmap.Config.ARGB_8888)!
		let canvas = Canvas(bitmap)
		tile.setBounds(0, 0, _tileSize!, _tileSize!)
		tile.draw(canvas)

		_tileArray[key] = bitmap
	}

	public override func onDraw(_ canvas: Canvas!) {
		super.onDraw(canvas)
		for x in 0 ..< XTileCount {
			for y in 0 ..< YTileCount {
				if (_tileGrid[x][y] > 0) {
					canvas.drawBitmap(_tileArray[_tileGrid[x][y]], _XOffset! + x * _tileSize!, _YOffset! + y * _tileSize!, _paint)
				}
			}
		}

	}

	/**
	 * Rests the internal array of Bitmaps used for drawing tiles, and sets the maximum index of
	 * tiles to be inserted
	 *
	 * @param tilecount
	 */
	func resetTiles(_ tilecount: Int) {
		_tileArray = Bitmap[](tilecount)
	}

	/**
	 * Used to indicate that a particular tile (set with loadTile and referenced by an integer)
	 * should be drawn at the given x/y coordinates during the next invalidate/draw cycle.
	 *
	 * @param tileindex
	 * @param x
	 * @param y
	 */
	func setTile(_ tileindex: Star, x: Int, y: Int) {
		_tileGrid[x][y] = tileindex
	}

	public override func onSizeChanged(_ w: Int32, _ h: Int32, _ oldw: Int32, _ oldh: Int32) {
		XTileCount = Int(Math.floor(w / _tileSize!))
		YTileCount = Int(Math.floor(h / _tileSize!))

		_XOffset = ((w - (_tileSize! * XTileCount!)) / 2)
		_YOffset = ((h - (_tileSize! * YTileCount!)) / 2)

		_tileGrid = Star[][](XTileCount)
		for i in 0 ..< XTileCount {
			_tileGrid[i] = Star[](YTileCount)
		}
		clearTiles()
	}

}