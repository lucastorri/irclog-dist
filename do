#!/bin/bash

cd `dirname "$0"`
DIR=`pwd`

updateAndDist() {
	PROJECT=$1
	echo
	echo "#########################"
	echo " $PROJECT "
	echo "#########################"
	echo
	
	if [ -d $PROJECT ]
	then
		cd $PROJECT
		git pull
		cd -
	else
		git clone "git://github.com/lucastorri/$PROJECT.git"
	fi
	
	cd $PROJECT
	./dist.sh
	ZIP_FILE=`ls -1 dist | grep .zip`
	unzip dist/$ZIP_FILE -d $DIR/dist
	cd -
	
	echo "#########################"
	echo "#########################"
}

cd $DIR
rm -rf dist
mkdir -p dist/{bin,data,index,logs,pids}

updateAndDist "ircbot"
updateAndDist "reindxr"
updateAndDist "irclog"

echo "#!/bin/bash

realpath() { ORIG=\`pwd\`; cd \$1; RET=\`pwd\`; cd \$ORIG; echo \$RET; }

ENV_DIR=\"\`dirname \$0\`/../\"

JAVA_BIN=\`which java\`
JAVA_BIN_DIR=\`readlink \$JAVA_BIN\`
export JAVA_HOME=\$(realpath \"\`dirname \$JAVA_BIN_DIR\`/../\")
export IRCLOG_DATA_DIR=\`realpath \$ENV_DIR\`/data/
export IRCLOG_INDEX_DIR=\`realpath \$ENV_DIR\`/index/
export IRCLOG_LOGS_DIR=\`realpath \$ENV_DIR\`/logs/
export IRCLOG_PIDS_DIR=\`realpath \$ENV_DIR\`/pids/
" > dist/bin/env.sh

chmod +x dist/bin/env.sh
