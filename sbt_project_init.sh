#!/bin/sh

function usage() {
  echo "Usage: sbt_project_init.sh -n 'project-name'"
}

function init_project() {
  local project_name="$1"

  mkdir -p "${project_name}"/src/{main,test}/{java,resources,scala} \
    && mkdir -p "${project_name}"/{lib,project,target} \
    && mkdir -p "${project_name}"/project/{project,target}

  cat > "${project_name}"/build.sbt << EOF
    organization := "io.sample"
    version      := "0.0.1"
    name         := "${project_name}"

    scalaVersion  := "2.12.6"
    scalacOptions := Seq("-unchecked", "-deprecation", "-encoding", "utf8")

    enablePlugins(JavaAppPackaging)
    mainClass in Universal := Some("io.sample.Main")
    executableScriptName := "start"

    libraryDependencies ++= Seq(
        "org.scalatest" % "scalatest_2.12" % "3.0.0" % "test",
        "com.typesafe" % "config" % "1.3.0"
      )
EOF
  
  touch "${project_name}"/project/plugins.sbt \
    && echo 'addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.3.4")' > "${project_name}"/project/plugins.sbt

  touch "${project_name}"/project/build.properties \
   && echo "sbt.version=1.1.5" > "${project_name}"/project/build.properties
  
  cat > "${project_name}"/.gitignore << EOF
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
}

function main() {
  while getopts ":n:h" opt; do
    case $opt in
      n)
        if [[ $OPTARG =~ ^[A-z-]{4,63}$ ]]; then
          init_project $OPTARG
        else 
          usage
        fi
        ;;
      h)
        usage
        exit 0
        ;;
      \?) 
        echo -e "\nInvalid option: -$OPTARG"
        usage
        exit 1
        ;;    
      : )
        echo -e "\nInvalid Option: -$OPTARG requires an argument"
        usage
        exit 1
        ;;
    esac
  done
  shift $((OPTIND -1))


  if [[ $? -eq 0 ]]; then
    exit 0
  else
    exit 1
  fi
}

main "$@"