# Base image
FROM nvcr.io/nvidia/pytorch:20.10-py3

# Upgrade conda
RUN conda update conda
RUN conda update --all

# Upgrade pip
RUN pip install -U pip

# Get rid of Dialog warnings
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y -q

# Update to latest PyTorch (build from source)
RUN pip uninstall -y torchvision
RUN pip uninstall -y torch
RUN git clone --recursive https://github.com/pytorch/pytorch
RUN cd pytorch && TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    pip install -v .
RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .    

# Latest Detectron2 (build from source)
RUN git clone https://github.com/facebookresearch/detectron2.git
RUN python -m pip install -e detectron2

# Install Bazel 3.4.1 (not latest) for building TRTorch
RUN apt-get update && apt-get install -y curl gnupg  && rm -rf /var/lib/apt/lists/*
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update && apt-get install -y bazel-3.4.1 && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/bazel-3.4.1 /usr/bin/bazel

# Workaround for bazel build expecting both static and shared versions, we only use shared libraries inside container
RUN cp /usr/lib/x86_64-linux-gnu/libnvinfer.so /usr/lib/x86_64-linux-gnu/libnvinfer_static.a

# Latest TRTorch (build from source) + CUDA 11.1 support and align to latest PyTorch
RUN apt-get update && apt-get install -y locales ninja-build && rm -rf /var/lib/apt/lists/* && locale-gen en_US.UTF-8
RUN git clone https://github.com/NVIDIA/TRTorch.git
COPY WORKSPACE TRTorch/WORKSPACE
COPY lowering.cpp TRTorch/core/lowering/lowering.cpp
RUN cd TRTorch && bazel build //:libtrtorch --compilation_mode opt
RUN cd TRTorch && cd py && python setup.py install --use-cxx11-abi
RUN conda init bash
ENV LD_LIBRARY_PATH /opt/conda/lib/python3.6/site-packages/torch/lib:$LD_LIBRARY_PATH

# Latest ONNX-TensorRT (build from source)
RUN git clone --recursive https://github.com/onnx/onnx-tensorrt
RUN cd onnx-tensorrt && mkdir build && cd build
RUN cd onnx-tensorrt && cd build && cmake .. -DTENSORRT_ROOT=/opt/tensorrt/bin && make -j
RUN cd onnx-tensorrt && cd build && export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH

# Latest ONNX runtime (from wheel)
RUN pip uninstall -y onnxruntime
RUN pip install -U onnxruntime

# Fix a vulnerability
RUN apt-get update && apt-get --only-upgrade install -y libfreetype6



