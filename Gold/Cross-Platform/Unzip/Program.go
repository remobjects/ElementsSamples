package Unzip

import (
"archive/zip"
"fmt"
"io"
"log"
"os"
"path/filepath"
"strings"
)

//func main() int { // E102 Invalid signature for "main" method. It must either have no parameters, or one parameter declared as String or array of String. It must have either no result value, or an Int32 as result.
//func main(args string[]) int {
func main() {
	writeLn("RemObjects Gold: Unzip Sample.")

	args := os.Args[1:]
	if args.Length != 2 {
		writeLn("Syntax: unzip <zip file> <target folder>")
		return //1
	}

	if !Exists(args[0]) {
		writeLn("File "+args[0]+" does not exist.")
		return //1
	}

	//if files, error := Unzip(args[0], args[1]) { // E17 Expression expected

	files, error := Unzip(args[0], args[1])
	if error != nil {
		writeLn(error)
		return //1
	}

	for _, file := range files {
		writeLn(file)
	}

	return //0
}

func Exists(name string) bool {
	if _, err := os.Stat(name); err != nil {
		if os.IsNotExist(err) {
			return false
		}
	}
	return true
}

func Unzip(src string, dest string) ([]string, error) {

	var filenames []string

	r, err := zip.OpenReader(src)
	if err != nil {
		return filenames, err
	}
	defer r.Close()

	for _, f := range r.File {

		// Store filename/path for returning and using later on
		fpath := filepath.Join(dest, f.Name)

		// Check for ZipSlip. More Info: http://bit.ly/2MsjAWE
		if !strings.HasPrefix(fpath, filepath.Clean(dest)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s: illegal file path", fpath)
		}

		filenames = append(filenames, fpath)

		if f.FileInfo().IsDir() {
			// Make Folder
			os.MkdirAll(fpath, os.ModePerm)
			continue
		}

		// Make File
		if err = os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return filenames, err
		}

		outFile, err := os.OpenFile(fpath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			return filenames, err
		}

		rc, err := f.Open()
		if err != nil {
			return filenames, err
		}

		_, err = io.Copy(outFile, rc)

		// Close the file without defer to close before next iteration of loop
		outFile.Close()
		rc.Close()

		if err != nil {
			return filenames, err
		}
	}
	return filenames, nil
}