package CallingNetApi

import (
	"fmt"
	"time"
)

// this demos shows how we can use regular .NET api functions from Go
// in this case System.Math and System.Globalization functions
// Process the array of numbers, sending the result of each one in a channel
// and notify main thread when done.
func main() {
	res := make(chan string)
	done := make(chan Boolean)
	allWork := []int{719477651, 812167122, 6194376521, 9213946712}

	go func(numbers []int) {
		for _, i := range numbers {
			toSend := System.Math.Log(System.Math.Sqrt(i)).ToString()
			res <- toSend + " done in " + System.DateTime.Now.ToString(System.Globalization.CultureInfo.CurrentCulture)
		}
		done<-true
	}(allWork)

	for {
		select {
		case msg1 := <-res:
			fmt.Println("received", msg1)
		case <-done: // all work finished
			return
		}
	}
}