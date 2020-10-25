# DeepLearningLab
Dockerfile for PyTorch/TorchScript/TensorRT and related development<br>
Aligned with nvcr.io version 20.10, e.g. latest Triton inference server (atm)

# Base image
nvcr.io/nvidia/tensorrt:20.10-py3

* Ubuntu 18.04
* TensorRT 7.2.1.
* Python 3.6.
* NVIDIA CUDA 11.1.0 including cuBLAS 11.2.1.
* NVIDIA cuDNN 8.0.4
* NVIDIA NCCL 2.7.8
* MLNX_OFED
* OpenMPI 3.1.6
* Nsight Compute 2020.2.0.18
* Nsight Systems 2020.3.4.32

# Changes
* PyTorch - build from latest source --- https://github.com/pytorch/pytorch
* TRTorch - build from latest source + CUDA 11.1 upgrade + PyTorch latest alignment --- https://github.com/NVIDIA/TRTorch
* ONNX-TensorRT - build from latest source --- https://github.com/onnx/onnx-tensorr
* Detectron2 - build from latest source --- https://github.com/facebookresearch/detectron2
* ONNX Runtime - GPU - wheel --- https://github.com/microsoft/onnxruntime

# Notes
* For TRTorch build Bazel 3.4.1 is installed (not the latest) as per the TRTorch repo
