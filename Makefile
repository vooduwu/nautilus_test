REGISTRY := local
.DEFAULT_GOAL :=
.PHONY: default
default: out/enclaveos.tar

out:
	mkdir out

out/enclaveos.tar: out \
	$(shell git ls-files \
		src/init \
		src/aws \
        src/hello \
	)
	docker build \
		--tag $(REGISTRY)/enclaveos \
		--progress=plain \
		--output type=local,rewrite-timestamp=true,dest=out\
		-f Containerfile \
		.

.PHONY: run
run: out/nitro.eif
	sudo nitro-cli \
		run-enclave \
		--cpu-count 2 \
		--memory 512M \
		--eif-path out/nitro.eif

.PHONY: run-debug
run-debug: out/nitro.eif
	sudo nitro-cli \
		run-enclave \
		--cpu-count 2 \
		--memory 512M \
		--eif-path out/nitro.eif \
		--debug-mode \
		--attach-console