DIR="onpremise"
if [ -d "$DIR" ]; then
   echo "'$DIR' repo already cloned"
else
   git clone https://github.com/getsentry/onpremise.git
fi

cd onpremise && ./install.sh --no-user-prompt
cd onpremise && docker-compose up -d
