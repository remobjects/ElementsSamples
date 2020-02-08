package SimpleGoRoutineChannel

import (
	"fmt"
	"time"
)

// Sample to show go routines and how to synchronize using channels. In this case we
// use the isFinished channel to notify when a go routine (doWork) finished.
func main() {
	// create the channel
	isFinished := make(chan bool, 1)

	// this is a go routine which is executed in a separate thread
	go doWork(isFinished)

	// wait until somebody write to the channel
	<-isFinished
	fmt.Println("Done!")
}

func doWork(isFinished chan bool) {
	fmt.Println("doing things...")
	time.Sleep(time.Second * 2)
	// at this point we send a value to the channel, so if there is any process waiting, it gets unblocked
	isFinished <- true
}