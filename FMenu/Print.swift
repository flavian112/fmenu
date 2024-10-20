import Foundation

func disableSystemLibraryLogs() {
    let devNull = fopen("/dev/null", "w")
    dup2(fileno(devNull), fileno(stderr))
    fclose(devNull)
}

func enableSystemLibraryLogs() {
    let originalStderr = dup(fileno(stderr))
    dup2(originalStderr, fileno(stderr))
}
