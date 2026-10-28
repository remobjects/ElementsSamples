package Unzip

import (
"archive/zip"
"fmt"
"io"
"os"
"path/filepath"
"strings"
)

func main() {
	writeLn("RemObjects Gold: Unzip Sample.")

	args := os.Args[1:]
	if args.Length != 2 {
		writeLn("Syntax: unzip <zip file> <target folder>")
		os.Exit(1)
		return
	}

	if !Exists(args[0]) {
		writeLn("File "+args[0]+" does not exist.")
		os.Exit(1)
		return
	}

	files, error := Unzip(args[0], args[1])
	if error != nil {
		writeLn(error.Error())
		os.Exit(1)
		return
	}

	for _, file := range files {
		writeLn(file)
	}

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
	dest, err := filepath.Abs(dest)
	if err != nil {
		return filenames, err
	}

	r, err := zip.OpenReader(src)
	if err != nil {
		return filenames, err
	}
	defer r.Close()

	for _, f := range r.File {
        // Reject traversal before joining: do not depend on a backend normalizing Join.
        entryName := strings.Replace(f.Name, "\\", "/", -1)
        if strings.HasPrefix(entryName, "/") || strings.Contains(entryName, ":") {
            return filenames, fmt.Errorf("%s: illegal file path", f.Name)
        }
        for _, part := range strings.Split(entryName, "/") {
            if part == ".." {
                return filenames, fmt.Errorf("%s: illegal file path", f.Name)
            }
        }
        if f.Mode() & os.ModeSymlink != 0 {
            return filenames, fmt.Errorf("%s: symbolic links are not extracted", f.Name)
        }


		// Store filename/path for returning and using later on
		fpath := filepath.Join(dest, entryName)

		// Check for ZipSlip. More Info: http://bit.ly/2MsjAWE
		if !strings.HasPrefix(fpath, filepath.Clean(dest)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s: illegal file path", fpath)
		}

		filenames = append(filenames, fpath)

		if f.FileInfo().IsDir() {
			// Make Folder
			if err := os.MkdirAll(fpath, os.ModePerm); err != nil {
				return filenames, err
			}
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
			outFile.Close()
			return filenames, err
		}

		_, err = io.Copy(outFile, rc)

		// Close the file without defer to close before next iteration of loop
		outputCloseError := outFile.Close()
		inputCloseError := rc.Close()

		if err != nil {
			return filenames, err
		}
		if outputCloseError != nil {
			return filenames, outputCloseError
		}
		if inputCloseError != nil {
			return filenames, inputCloseError
		}
	}
	return filenames, nil
}