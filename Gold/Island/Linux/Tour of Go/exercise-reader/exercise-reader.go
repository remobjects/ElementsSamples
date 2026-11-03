// Demonstrates io.Reader with an infinite stream of the letter A.
package main

import "golang.org/x/tour/reader"

type MyReader struct{}

func (MyReader) Read(p []byte) (int, error) {
	for i := range p {
		p[i] = 'A'
	}
	return len(p), nil
}

func main() {
	reader.Validate(MyReader{})
}
