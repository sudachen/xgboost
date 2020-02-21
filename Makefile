
build: build-cpu build-gpu



build-cpu: libxgboost-cpu.tar.lzma libxgboost-cpu.lzma

libxgboost-cpu.lzma: lib/libxgboost_cpu.so
	xz -v -z -9 -c > libxgboost-cpu.lzma lib/libxgboost_cpu.so

libxgboost-cpu.tar.lzma: lib/libxgboost_cpu.so
	-rm -rf ./dist-cpu
	mkdir -p ./dist-cpu/opt/xgboost/lib ./dist-cpu/opt/xgboost/include/xgboost
	cp lib/libxgboost_cpu.so ./dist-cpu/opt/xgboost/lib/libxgboost_cpu.so
	cp include/xgboost/c_api.h ./dist-cpu/opt/xgboost/include/xgboost
	ln -s ./libxgboost_cpu.so ./dist-cpu/opt/xgboost/lib/libxgboost.so
	cd ./dist-cpu/ && tar c opt | xz -9 -z -v -c > ../libxgboost-cpu.tar.lzma

lib/libxgboost_cpu.so:
	-rm -rf ./.build-cpu
	mkdir ./.build-cpu
	-rm lib/libxgboost.so
	cd ./.build-cpu && cmake .. && make -j6
	cp lib/libxgboost.so lib/libxgboost_cpu.so


build-gpu: libxgboost-gpu.lzma

libxgboost-gpu.lzma: lib/libxgboost_gpu.so
	xz -v -z -9 -c > libxgboost_gpu.lzma lib/libxgboost_gpu.so

lib/libxgboost_gpu.so:
	-rm -rf ./.build-gpu
	mkdir ./.build-gpu
	-rm lib/libxgboost.so
	cd ./.build-gpu && cmake .. -DUSE_CUDA=ON  -DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc && make -j6
	cp lib/libxgboost.so lib/libxgboost_gpu.so
