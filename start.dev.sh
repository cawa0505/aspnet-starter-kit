#!/bin/sh
cd /usr/src/app && node tools/clean && node tools/bundle

nohup node tools/start > /dev/null 2>&1 &

cd /usr/src/app/server && dotnet run

