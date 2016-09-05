#!/bin/bash
set -e
export PYTHONPATH=$MIST_HOME/src/main/python:$SPARK_HOME/python/:`readlink -f $SPARK_HOME/python/lib/py4j*`:$PYTHONPATH
cd $MIST_HOME

if [ "$1" = 'tests' ]; then
  $SPARK_HOME/sbin/start-master.sh
  $SPARK_HOME/sbin/start-slave.sh localhost:7077
  ./sbt/sbt -DsparkVersion=$SPARK_VERSION -Dconfig.file=configs/tests.conf test
elif [ "$1" = 'master' ]; then
  ./mist.sh master --config configs/docker.conf --jar target/scala-*/mist-assembly-*.jar
elif [ "$1" = 'worker' ]; then
  ./mist.sh worker --runner local --namespace $2 --config configs/docker.conf --jar target/scala-*/mist-assembly-*.jar
else
  exec "$@"
fi
