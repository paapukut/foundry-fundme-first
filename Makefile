# when this makefile is here we dont want to do source.env tomake the .env file visible
# for that you have to add -include .env
-include .env
# THIS FILE IS TO MAKE SHORTCUTS FOR THE TERMINAL COMMANDS
#for making a SHORTCUT for forge build "build:; forge build" now wecan use "make build" insted of forge build
#first use the make command and after the shortcut
build:; forge build
#insted of using the big long command we only need to type "make run" command
run:; forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80