fuzz:
	fuzz arm
	truffle compile
	ganache --deterministic &> /dev/null &
	truffle exec scripts/seed.js
	fuzz run
	pkill -f ganache
	fuzz disarm


clean:
	rm -rf ./build
	test .scribble-arming.meta.json && fuzz disarm