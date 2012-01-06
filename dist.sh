#!/bin/bash

updateProject() {
	PROJECT=$1
	
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
	unzip dist/`ls -1 dist | grep .zip` -d $DIR/dist
	cd -
}

DIR=`dirname "$0"`
cd DIR
rm -rf dist
mkdir dist

updateAndDist("ircbot")
updateAndDist("reindxr")
updateAndDist("irclog")

echo "#!/bin/bash

ENV_DIR=\`basename \"\$0\"\`

export JAVA_HOME=\${readlink \`which java\`}
export IRCLOG_DATA_DIR=\$ENV_DIR/data/
export IRCLOG_INDEX_DIR=\$ENV_DIR/index/
export IRCLOG_LOGS_DIR=\$ENV_DIR/logs/
export IRCLOG_PIDS_DIR=\$ENV_DIR/pids/
"

 > dist/env.sh