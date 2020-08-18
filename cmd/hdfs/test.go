package main

import "os"

func test(paths []string, exists bool, isdir bool) {
	paths, client, err := getClientAndExpandedPaths(paths)
	if err != nil {
		fatal(err)
	}

	if len(paths) == 0 {
		return
	}

	fileInfo, err := client.Stat(paths[0])

	if err != nil {
		if !exists && !isdir {
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
}
