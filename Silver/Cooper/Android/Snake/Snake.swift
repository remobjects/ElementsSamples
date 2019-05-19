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

import android.app
import android.os
import android.view
import android.widget

/**
 * Snake: a simple game that everyone can enjoy.
 *
 * This is an implementation of the classic Game "Snake", in which you control a serpent roaming
 * around the garden looking for apples. Be careful, though, because when you catch one, not only
 * will you become longer, but you'll move faster. Running into yourself or the walls will end the
 * game.
 **/
public class Snake : Activity {

	class let ICICLE_KEY = "snake-view"
	var _snakeView: SnakeView!

	// Called when Activity is first created. Turns off the title bar, sets up the content views, and fires up the SnakeView.
	public override func onCreate(_ savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState)

		setContentView(R.layout.snake_layout)

		_snakeView = findViewById(R.id.snake) as! SnakeView
		_snakeView.setDependentViews(msgView: findViewById(R.id.text) as! TextView, arrowView: findViewById(R.id.arrowContainer)!, backgroundView: findViewById(R.id.background)!)

		if (savedInstanceState == nil) {
			// We were just launched -- set up a new game
			_snakeView!.setMode(.READY)
		} else {
			// We are being restored
			let map = savedInstanceState.getBundle(ICICLE_KEY)
			if let m = map {
				_snakeView.restoreState(m)
			} else {
				_snakeView.setMode(.PAUSE)
			}
		}
		_snakeView.setOnTouchListener( { (v: View!, event: MotionEvent!) -> Bool in  // TODO use non-trailing clousure

			if (self._snakeView.getGameState() == Mode.RUNNING) {
				// Normalize x,y between 0 and 1
				let x = event.getX() / v.getWidth()
				let y = event.getY() / v.getHeight()

				// Direction will be [0,1,2,3] depending on quadrant
				var direction = 0
				direction = (x > y) ? 1 : 0
				direction |= (x > 1 - y) ? 2 : 0

				// Direction is same as the quadrant which was clicked
				self._snakeView.moveSnake(direction as! Move)

			} else {
				// If the game is not running then on touching any part of the screen
				// we start the game by sending MOVE_UP signal to SnakeView
				self._snakeView.moveSnake(.MOVE_UP)
			}
			return false
		})
	}

	public override func onPause() {
		super.onPause()
		// Pause the game along with the activity
		_snakeView.setMode(.PAUSE)
	}

	public override func onSaveInstanceState(_ outState: Bundle!) {
		outState.putBundle(ICICLE_KEY, _snakeView.saveState())
	}

	// Handles key events in the game. Update the direction our snake is traveling based on the DPAD.
	public override func onKeyDown(_ keyCode: Int32, _ msg: KeyEvent?) -> Bool {

		switch (keyCode) {
			case KeyEvent.KEYCODE_DPAD_UP:
				_snakeView.moveSnake(.MOVE_UP)
				break
			case KeyEvent.KEYCODE_DPAD_RIGHT:
				_snakeView.moveSnake(.MOVE_RIGHT)
				break
			case KeyEvent.KEYCODE_DPAD_DOWN:
				_snakeView.moveSnake(.MOVE_DOWN)
				break
			case KeyEvent.KEYCODE_DPAD_LEFT:
				_snakeView.moveSnake(.MOVE_LEFT)
				break
			default:
				break
		}

		return super.onKeyDown(keyCode, msg)
	}

}
