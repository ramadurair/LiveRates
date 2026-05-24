#!/bin/sh
set -e
GRADLE_OPTS="${GRADLE_OPTS:-"-Xmx2048m -Dfile.encoding=UTF-8"}"
APP_HOME="$(cd "$(dirname "$0")" && pwd)"
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
if [ -n "$JAVA_HOME" ]; then JAVACMD="$JAVA_HOME/bin/java"; else JAVACMD="java"; fi
exec "$JAVACMD" $GRADLE_OPTS \
  "-Dorg.gradle.appname=gradlew" \
  -classpath "$WRAPPER_JAR" \
  org.gradle.wrapper.GradleWrapperMain "$@"
