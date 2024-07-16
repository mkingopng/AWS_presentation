#!/bin/bash

sam build

# test the lambda locally before zipping and deploying
sam local invoke MyFunction --env-vars env.json --event test_event.json
