#!/usr/bin/env groovy

System.setProperty('java.awt.headless', 'true')

@GrabResolver(name='imagej.public', root='https://maven.imagej.net/content/groups/public')
@Grab('io.scif:scifio:0.38.0')
import io.scif.FilePattern
import io.scif.SCIFIO
import org.scijava.io.location.FileLocation

def output(message) { println(message) }
def warn(message) { System.err.println("[WARNING] $message") }

def process(location) {
  if (!location.exists()) {
    warn("Non-existent file: '${location.getPath()}'")
    return
  }
  // Regular file; analyze the file pattern.
  fp = new FilePattern(scifio.context(), location)
  if (!fp.isValid()) {
    warn("Invalid file pattern: '${fp.getPattern()}': ${fp.getErrorMessage()}")
    output(path)
    input.remove(path)
    return
  }
  output(fp.getPattern())
  input.removeAll(fp.getFiles() as List)
}

scifio = new SCIFIO()
try {
  input = [] as Set
  input.addAll(args)
  while (!input.isEmpty()) {
    path = input.iterator().next()
    location = new FileLocation(path)
    if (location.isDirectory()) {
      // Process all files of directory arguments.
      input.addAll(location.listFiles())
    }
    else process(location)
  }
}
finally {
  scifio.context().dispose()
}
