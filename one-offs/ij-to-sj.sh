#!/bin/sh

#
# ij-to-sj.sh
#
# A quick script to update SciJava projects:
# - Convert from maven.imagej.net to maven.scijava.org.
# - Convert Travis from Oracle JDK 8 to OpenJDK 8.

update() {
	(
		if [ ! -d "$1" ]
		then
			echo "[WARNING] No such directory: $1"
			return
		fi
		cd "$1"
		if [ -f pom.xml ]
		then
			sed -i '' -e 's/maven.imagej.net/maven.scijava.org/g' pom.xml
			sed -i '' -e 's/deploy-to-imagej/deploy-to-scijava/g' pom.xml
			sed -i '' -e 's/ImageJ Maven repository/SciJava Maven repository/g' pom.xml
			sed -i '' -e 's/imagej.public/scijava.public/g' pom.xml
			sed -i '' -e 's/^		<version>.*/		<version>26.0.0<\/version>/' pom.xml
			git ci -m 'POM: maven.imagej.net -> maven.scijava.org' pom.xml
		fi
		if [ -f .travis.yml ]
		then
			sed -i '' -e 's/jdk: oraclejdk8/jdk: openjdk8/' .travis.yml
			git ci -m 'Travis: build using openjdk8' .travis.yml
		fi
	)
}

if [ $# -eq 0 ]
then
	echo "Usage: ij-to-sj.sh <dir-to-update> <another-dir-to-update> ..."
fi

for arg in $@
do
	echo
	echo "== $arg =="
	update "$arg"
done
exit 1
