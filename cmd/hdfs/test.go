package main

import (
	"os"
)

func test(paths []string, exists, isdir, readable, sizegreaterzero bool) {
	paths, client, err := getClientAndExpandedPaths(paths)
	if err != nil {
		fatal(err)
	}

	if len(paths) == 0 {
		return
	}

	fileInfo, err := client.Stat(paths[0])

	if err != nil {
		if !exists && !isdir && !readable && !sizegreaterzero {
			return
		}
		os.Exit(1)
	}

	if exists {
		return
	}

	if isdir {
		if fileInfo.IsDir() {
			return
		} else {
			os.Exit(1)
		}
	}

	if readable {
		var err error
		if fileInfo.IsDir() {
			_, err = client.ReadDir(paths[0])
		} else {
			_, err = client.ReadFile(paths[0])
		}
		if err != nil {
			os.Exit(1)
		}
		os.Exit(0)
	}

	if sizegreaterzero {
		if fileInfo.IsDir() {
			os.Exit(0)
		}
		if fileInfo.Size() > 0 {
			os.Exit(0)
		}
		os.Exit(1)
	}
}
