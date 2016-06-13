#!/bin/sh
cd /usr/src/app && node tools/clean && node tools/bundle

cd /usr/src/app/server && dotnet run

