/*
 * Copyright (C) 2007 The Android Open Source Project
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
import android.os
import android.util
import android.view
import android.widget
import java.util

enum Direction : Int32 {
	case NORTH = 1
	case SOUTH = 2
	case EAST = 3
	case WEST = 4
}

enum Mode : Int32 {
	case PAUSE = 0
	case READY = 1
	case RUNNING = 2
	case LOSE = 3
}

enum Move : Int32 {
	case MOVE_LEFT = 0
	case MOVE_UP = 1
	case MOVE_DOWN = 2
	case MOVE_RIGHT = 3
}

enum Star : Int32 {
	case NONE = 0
	case RED_STAR = 1
	case YELLOW_STAR = 2
	case GREEN_STAR = 3
}

/**
 * SnakeView: implementation of a simple game of Snake
 */
public class SnakeView : TileView {

	class let TAG = "SnakeView"

	/**
	 * Current mode of application: READY to run, RUNNING, or you have already lost. static final
	 * ints are used instead of an enum for performance reasons.
	 */
	var _mode = Mode.READY

	/**
	 * Current direction the snake is headed.
	 */
	var _direction = Direction.NORTH
	var _nextDirection = Direction.NORTH

	/**
	 * _score: Used to track the number of apples captured _moveDelay: number of milliseconds
	 * between snake movements. This will decrease as apples are captured.
	 */
	var _score = 0
	var _moveDelay = 600

	/**
	 * _lastMove: Tracks the absolute time when the snake last moved, and is used to determine if a
	 * move should be made based on _moveDelay.
	 */
	var _lastMove: Int?

	/**
	 * _statusText: Text shows to the user in some run states
	 */
	var _statusText: TextView!

	/**
	 * _arrowsView: View which shows 4 arrows to signify 4 directions in which the snake can move
	 */
	var _arrowsView: View!

	/**
	 * _backgroundView: Background View which shows 4 different colored triangles pressing which
	 * moves the snake
	 */
	var _backgroundView: View!

	/**
	 * _snakeTrail: A list of Coordinates that make up the snake's body _appleList: The secret
	 * location of the juicy apples the snake craves.
	 */
	var _snakeTrail = ArrayList<Coordinate>()
	var _appleList = ArrayList<Coordinate>()

	/**
	 * Everyone needs a little randomness in their life
	 */
	let RNG = Random()

	/**
	 * Create a simple handler that we can use to cause animation to happen. We set ourselves as a
	 * target and we can use the sleep() function to cause an update/invalidate to occur at a later
	 * date.
	 */

	let _redrawHandler = RefreshHandler(outer: self)

	class RefreshHandler : Handler {

		let outer: SnakeView!; // todo: should not need to be nullable if set in init()

		public init(outer: SnakeView) {
			self.outer = outer;
		}

		public override func handleMessage(_ msg: Message!) {
			outer.update()
			outer.invalidate()
		}

		func sleep(milliseconds delayMillis: Int) {
			removeMessages(0)
			sendMessageDelayed(obtainMessage(0), delayMillis)
		}
	}

	/**
	 * Constructs a SnakeView based on inflation from XML
	 *
	 * @param context
	 * @param attrs
	 */
	public init(context: Context, attrs: AttributeSet) {
		super.init(context, attrs)
		initSnakeView(context)
	}

	public init(context: Context, attrs: AttributeSet, defStyle: Int) {
		super.init(context, attrs, defStyle)
		initSnakeView(context)
	}

	func initSnakeView(_ context: Context) {

		setFocusable(true)

		let r = self.getContext().getResources()

		resetTiles(4)
		
		loadTile(tile: r.getDrawable(R.drawable.redstar)!, key: .RED_STAR)
		loadTile(tile: r.getDrawable(R.drawable.yellowstar)!, key: .YELLOW_STAR)
		loadTile(tile: r.getDrawable(R.drawable.greenstar)!, key: .GREEN_STAR)
	}

	func initNewGame() {
		_snakeTrail.clear()
		_appleList.clear()

		// For now we're just going to load up a short default eastbound snake
		// that's just turned north

		_snakeTrail.add(Coordinate(X: 7, Y: 7))
		_snakeTrail.add(Coordinate(X: 6, Y: 7))
		_snakeTrail.add(Coordinate(X: 5, Y: 7))
		_snakeTrail.add(Coordinate(X: 4, Y: 7))
		_snakeTrail.add(Coordinate(X: 3, Y: 7))
		_snakeTrail.add(Coordinate(X: 2, Y: 7))
		_nextDirection = .NORTH

		// Two apples to start with
		addRandomApple()
		addRandomApple()

		_moveDelay = 600
		_score = 0
	}

	/**
	 * Given a ArrayList of coordinates, we need to flatten them into an array of ints before we can
	 * stuff them into a map for flattening and storage.
	 *
	 * @param cvec : a ArrayList of Coordinate objects
	 * @return : a simple array containing the x/y values of the coordinates as
	 *		 [x1,y1,x2,y2,x3,y3...]
	 */
	func coordArrayListToArray(_ cvec: ArrayList<Coordinate>) -> Int32[]! {

		var rawArray = Int32[]!(cvec.size() * 2)

		var i = 0
		for c in cvec {
			rawArray[i++] = c.X
			rawArray[i++] = c.Y
		}

		return rawArray
	}

	/**
	 * Save game state so that the user does not lose anything if the game process is killed while
	 * we are in the background.
	 *
	 * @return a Bundle with this view's state
	 */
	func saveState() -> Bundle {
		let map = Bundle()

		map.putIntArray("_appleList", coordArrayListToArray(_appleList))
		map.putInt("_direction", _direction as! Int)
		map.putInt("_nextDirection", _nextDirection as! Int)
		map.putDouble("_moveDelay", _moveDelay)
		map.putLong("_score", _score)
		map.putIntArray("_snakeTrail", coordArrayListToArray(_snakeTrail))

		return map
	}

	/**
	 * Given a flattened array of ordinate pairs, we reconstitute them into a ArrayList of
	 * Coordinate objects
	 *
	 * @param rawArray : [x1,y1,x2,y2,...]
	 * @return a ArrayList of Coordinates
	 */
	func coordArrayToArrayList(_ rawArray: Int32[]!) -> ArrayList<Coordinate> {
		let coordArrayList = ArrayList<Coordinate>()

		let coordCount = rawArray.length
		for var index = 0; index < coordCount; index += 2 {
			let c = Coordinate(X: rawArray[index], Y: rawArray[index + 1])
			coordArrayList.add(c)
		}
		return coordArrayList
	}

	/**
	 * Restore game state if our process is being relaunched
	 *
	 * @param icicle a Bundle containing the game state
	 */
	func restoreState(_ icicle: Bundle) {
		setMode(.PAUSE)

		_appleList = coordArrayToArrayList(icicle.getIntArray("_appleList"))
		_direction = icicle.getInt("_direction") as! Direction
		_nextDirection = icicle.getInt("_nextDirection") as! Direction
		_moveDelay = icicle.getInt("_moveDelay")
		_score = icicle.getLong("_score")
		_snakeTrail = coordArrayToArrayList(icicle.getIntArray("_snakeTrail"))
	}

	/**
	 * Handles snake movement triggers from Snake Activity and moves the snake accordingly. Ignore
	 * events that would cause the snake to immediately turn back on itself.
	 *
	 * @param direction The desired direction of movement
	 */
	func moveSnake(_ direction: Move) {

		if (direction == Move.MOVE_UP) {
			if (_mode == Mode.READY || _mode == Mode.LOSE) {
				/*
				 * At the beginning of the game, or the end of a previous one,
				 * we should start a new game if UP key is clicked.
				 */
				initNewGame()
				setMode(.RUNNING)
				update()
				return
			}

			if (_mode == Mode.PAUSE) {
				/*
				 * If the game is merely paused, we should just continue where we left off.
				 */
				setMode(.RUNNING)
				update()
				return
			}

			if (_direction != Direction.SOUTH) {
				_nextDirection = Direction.NORTH
			}
			return
		}

		if (direction == Move.MOVE_DOWN) {
			if (_direction != Direction.NORTH) {
				_nextDirection = .SOUTH
			}
			return
		}

		if (direction == Move.MOVE_LEFT) {
			if (_direction != Direction.EAST) {
				_nextDirection = .WEST
			}
			return
		}

		if (direction == Move.MOVE_RIGHT) {
			if (_direction != Direction.WEST) {
				_nextDirection = .EAST
			}
			return
		}

	}

	/**
	 * Sets the Dependent views that will be used to give information (such as "Game Over" to the
	 * user and also to handle touch events for making movements
	 *
	 * @param newView
	 */
	func setDependentViews(msgView: TextView, arrowView: View, backgroundView: View) {
		_statusText = msgView
		_arrowsView = arrowView
		_backgroundView = backgroundView
	}

	/**
	 * Updates the current mode of the application (RUNNING or PAUSED or the like) as well as sets
	 * the visibility of textview for notification
	 *
	 * @param newMode
	 */
	func setMode(_ newMode: Mode) {
		let oldMode = _mode
		_mode = newMode

		if (newMode == Mode.RUNNING && oldMode != Mode.RUNNING) {
			// hide the game instructions
			_statusText.setVisibility(View.INVISIBLE)
			update()
			// make the background and arrows visible as soon the snake starts moving
			_arrowsView.setVisibility(View.VISIBLE)
			_backgroundView.setVisibility(View.VISIBLE)
			return
		}

		let res = getContext().getResources()
		var str = ""
		if newMode == Mode.PAUSE {
			_arrowsView.setVisibility(View.GONE)
			_backgroundView.setVisibility(View.GONE)
			str = res.getText(R.string.mode_pause).toString()!
		}
		if newMode == Mode.READY {
			_arrowsView.setVisibility(View.GONE)
			_backgroundView.setVisibility(View.GONE)

			str = res.getText(R.string.mode_ready).toString()!
		}
		if newMode == Mode.LOSE {
			_arrowsView.setVisibility(View.GONE)
			_backgroundView.setVisibility(View.GONE)
			str = res.getString(R.string.mode_lose, _score)!
		}

		_statusText.setText(str)
		_statusText.setVisibility(View.VISIBLE)
	}

	/**
	 * @return the Game state as Running, Ready, Paused, Lose
	 */
	func getGameState() -> Mode {
		return _mode
	}

	/**
	 * Selects a random location within the garden that is not currently covered by the snake.
	 * Currently _could_ go into an infinite loop if the snake currently fills the garden, but we'll
	 * leave discovery of this prize to a truly excellent snake-player.
	 */
	func addRandomApple() {
		var newCoord: Coordinate? = nil
		var found = false
		while (!found) {
			// Choose a new location for our apple
			let newX = 1 + RNG.nextInt(XTileCount - 2)
			let newY = 1 + RNG.nextInt(YTileCount - 2)
			newCoord = Coordinate(X: newX, Y: newY)

			// Make sure it's not already under the snake
			var collision = false
			let snakelength = _snakeTrail.size()
			for index in 0 ..< snakelength {
				if (_snakeTrail.get(index).equals(newCoord)) {
					collision = true
				}
			}
			// if we're here and there's been no collision, then we have
			// a good location for an apple. Otherwise, we'll circle back
			// and try again
			found = !collision
		}
		if (newCoord == nil) {
			Log.e(TAG, "Somehow ended up with a null newCoord!")
		}
		_appleList.add(newCoord!)
	}

	/**
	 * Handles the basic update loop, checking to see if we are in the running state, determining if
	 * a move should be made, updating the snake's location.
	 */
	func update() {
		if (_mode == Mode.RUNNING) {
			let now = System.currentTimeMillis()!

			if (_lastMove == nil || (now - _lastMove! > _moveDelay)) {
				clearTiles()
				updateWalls()
				updateSnake()
				updateApples()
				_lastMove = now
			}
			_redrawHandler.sleep(milliseconds: _moveDelay)
		}

	}

	/**
	 * Draws some walls.
	 */
	func updateWalls() {
		for x in 0 ..< XTileCount {
			setTile(.GREEN_STAR, x: x, y: 0)
			setTile(.GREEN_STAR, x: x, y: YTileCount - 1)
		}
		for y in 1 ..< YTileCount-1 {
			setTile(.GREEN_STAR, x: 0, y: y)
			setTile(.GREEN_STAR, x: XTileCount - 1, y: y)
		}
	}

	/**
	 * Draws some apples.
	 */
	func updateApples() {
		for c in _appleList {
			setTile(.YELLOW_STAR, x: c.X, y: c.Y)
		}
	}

	/**
	 * Figure out which way the snake is going, see if he's run into anything (the walls, himself,
	 * or an apple). If he's not going to die, we then add to the front and subtract from the rear
	 * in order to simulate motion. If we want to grow him, we don't subtract from the rear.
	 */
	func updateSnake() {
		var growSnake = false

		// Grab the snake by the head
		let head = _snakeTrail.get(0)
		var newHead = Coordinate(X: 1, Y: 1)

		_direction = _nextDirection

		switch (_direction) {
			case Direction.EAST:  // TODO
				newHead = Coordinate(X: head.X + 1, Y: head.Y)
				break
			
			case Direction.WEST: 
				newHead = Coordinate(X: head.X - 1, Y: head.Y)
				break
			
			case Direction.NORTH: 
				newHead = Coordinate(X: head.X, Y: head.Y - 1)
				break
			
			case Direction.SOUTH: 
				newHead = Coordinate(X: head.X, Y: head.Y + 1)
				break
			
		}

		// Collision detection
		// For now we have a 1-square wall around the entire arena
		if newHead.X < 1 || newHead.Y < 1 || newHead.X > XTileCount - 2 || newHead.Y > YTileCount - 2 {
			setMode(.LOSE)
			return

		}

		// Look for collisions with itself
		let snakelength = _snakeTrail.size()
		for snakeindex in 0 ..< snakelength {
			let c = _snakeTrail.get(snakeindex)
			if c == newHead {
				setMode(.LOSE)
				return
			}
		}

		// Look for apples
		let applecount = _appleList.size()
		for appleindex in 0 ..< applecount {
			let c = _appleList.get(appleindex)
			if c == newHead {
				_appleList.remove(c)
				addRandomApple()

				_score += 1
				_moveDelay = Int(Double(_moveDelay) * 0.9)

				growSnake = true
			}
		}

		// push a new head onto the ArrayList and pull off the tail
		_snakeTrail.add(0, newHead)
		// except if we want the snake to grow
		if !growSnake {
			_snakeTrail.remove(_snakeTrail.size() - 1)
		}

		var index = 0
		for c in _snakeTrail {
			if (index == 0) {
				setTile(.YELLOW_STAR, x: c.X, y: c.Y)
			} else {
				setTile(.RED_STAR, x: c.X, y: c.Y)
			}
			index += 1
		}

	}


}

/**
 * Simple class containing two integer values and a comparison function. There's probably
 * something I should use instead, but this was quick and easy to build.
 */
class Coordinate {
	var X: Int
	var Y: Int

	public init(X: Int, Y: Int) { // TODO: this should be auto-generated
		self.X = X;
		self.Y = Y;
	}

	func ==(lhs: Coordinate!, rhs: Coordinate!) -> Bool{
	  if ((lhs as! Object) == nil) != ((rhs as! Object) == nil) {
	    return false;
	  }
	  if ((lhs as! Object) == nil) {
	    return true;
	  } 
		if (lhs.X == rhs.X) && (lhs.Y == rhs.Y) {
			return true
		}
		return false
	}

	public override func toString() -> String {
		return ("Coordinate: [" + X + "," + Y + "]")! // TODO workaround forconcat returning !
	}
}
