#!/bin/sh

# Check of project name is provided
if [ -z "$1" ]
  then
   echo "Usage: sbt_project_init.sh PROJECT_NAME"
   exit 1
fi 

PROJECT_NAME=$1

# create project skeleton 
mkdir -p $PROJECT_NAME/src/{main,test}/{java,resources,scala}
mkdir -p $PROJECT_NAME/{lib,project,target}
mkdir -p $PROJECT_NAME/project/{project,target}

# create build.sbt file
cat > $PROJECT_NAME/build.sbt << EOF
  // Project related information
  organization := "org.angmic"
  version := "0.0.1"
  name := "$PROJECT_NAME"

  // Scala language related information
  ivyScala := ivyScala.value map {
    _.copy(overrideScalaVersion = true)
  }                                     // Forces the Scala version
  scalaVersion := "2.11.8"
  scalacOptions := Seq(
    "-unchecked",
    "-deprecation",
    "-encoding",
    "utf8")

  //Packaging and excecution instractions
  enablePlugins(JavaAppPackaging)                             // Enables packaging  and spesifies the type of the package
  mainClass in Universal := Some("com.example.package.Class") // Specifies the class with the 'main' methods
  executableScriptName := "start"

  // External dependencies of the project
  libraryDependencies ++= {
    // val akkaVersion = "2.4.9"
    Seq(
      "org.scalatest" % "scalatest_2.11" % "3.0.0",
      "com.typesafe" % "config" % "1.3.0"
    )
  } 
EOF

# create project/plugins.sbt file
cat > $PROJECT_NAME/project/plugins.sbt << EOF
  addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.0.0-RC2")
  addSbtPlugin("io.spray" % "sbt-revolver" % "0.8.0")
EOF

# create project/build.properties file
cat > $PROJECT_NAME/project/build.properties << EOF
  sbt.version=0.13.12
EOF

# create resources/application.conf file
touch $PROJECT_NAME/src/main/resources/application.conf

# create project/build.properties file
cat > $PROJECT_NAME/project/build.properties << EOF
  sbt.version=0.13.12
EOF

# create .gitignore file
cat > $PROJECT_NAME/.gitignore << EOF
  *.class
  *.log

  # sbt specific
  dist/*
  target/
  project/plugins/project/
  project/targtet/

  # Idea specific
  .idea
  .idea_modules
EOF