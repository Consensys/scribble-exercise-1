fuzz:
	fuzz arm
	truffle compile
	ganache --deterministic &> /dev/null &
	truffle exec scripts/seed.js
	fuzz run
	pkill -f ganache
	fuzz disarm

fuzz-hardhat:
	fuzz -c .fuzz_hardhat.yml arm
	npx hardhat compile
	ganache --deterministic &> /dev/null &
	npx hardhat run --network localhost scripts/hardhat_seed.js
	fuzz -c .fuzz_hardhat.yml run
	pkill -f ganache
	fuzz -c .fuzz_hardhat.yml disarm

clean:
	rm -rf ./build
	test .scribble-arming.meta.json && fuzz disarm
