#Need to use "docker build  -t mns-fe-starter-kit:latest . --build-arg NPM_TOKEN=<token>" in manual build
FROM node:10.15 AS build

COPY package.json /package.json 

COPY newRelic.js /newRelic.js

COPY package-lock.json /package-lock.json   

RUN --mount=type=secret,id=npmToken \
    npm config set //registry.npmjs.org/:_authToken $(cat /run/secrets/npmToken) \
    npm config set scope mands \
    npm config set @mands:registry https://registry.npmjs.org/

RUN git config --global url.https://.insteadOf git://

EXPOSE 3000

RUN npm install

COPY scripts/create-npmrc.sh /create-npmrc.sh   
COPY utilities /utilities   

COPY .babelrc /.babelrc 
COPY config /config 
COPY src /src
RUN npm run bundle
CMD npm run start