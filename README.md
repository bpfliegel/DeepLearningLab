# DeepLearningLab
Dockerfile for PyTorch/TorchScript/TensorRT and related development<br>
Aligned with nvcr.io version 20.10, e.g. latest Triton inference server (atm)

# Base image
FROM nvcr.io/nvidia/pytorch:20.10-py3<br>
https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-10.html

* Ubuntu 18.04
* Python 3.6
* NVIDIA CUDA 11.1.0 including cuBLAS 11.2.1
* NVIDIA cuDNN 8.0.4
* NVIDIA NCCL 2.7.8
* APEX
* MLNX_OFED
* OpenMPI 4.0.5
* TensorBoard 1.15.0+nv
* Nsight Compute 2020.2.0.18
* Nsight Systems 2020.3.4.32
* TensorRT 7.2.1
* DALI 0.26.0
* MAGMA 2.5.2
* DLProf 0.16.0
* PyProf r20.10

# Changes
* PyTorch - build from latest source --- https://github.com/pytorch/pytorch
* TRTorch - build from latest source + CUDA 11.1 upgrade + PyTorch latest alignment --- https://github.com/NVIDIA/TRTorch
* ONNX-TensorRT - build from latest source --- https://github.com/onnx/onnx-tensorr
* Detectron2 - build from latest source --- https://github.com/facebookresearch/detectron2
* ONNX Runtime - CPU - wheel --- https://github.com/microsoft/onnxruntime

# Notes
* For TRTorch build Bazel 3.4.1 is installed (not the latest) as per the TRTorch repo
