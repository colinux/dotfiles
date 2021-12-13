if test ! $(which yarn)
then
    npm install -g yarn
fi

if test ! $(which expo)
then
    npm install -g expo-cli eas-cli @expo/ngrok
fi

if test ! $(which lt)
then
    npm install -g localtunnel
fi

if test ! $(which react-devtools)
then
    npm install -g react-devtools @vue/devtools
fi

if test ! $(which sentry-cli)
then
    npm install -g @sentry/cli
fi
