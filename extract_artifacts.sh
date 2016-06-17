#!/bin/sh

rm -rf dist/eccenca* dist/data*

unzip -d dist artifacts/eccenca-DataIntegration*
unzip -d dist artifacts/eccenca-DataManager*
unzip -d dist artifacts/eccenca-DataPlatform*

cd dist

mv eccenca-DataIntegration* dataintegration
mv eccenca-DataManager* datamanager
mv eccenca-DataPlatform* dataplatform

cd ..