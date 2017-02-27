#ifndef CUDNN_PROJ_MSELAYER_H
#define CUDNN_PROJ_MSELAYER_H


#include "Layer.cuh"


class MSELayer: public Layer {
public:
    cudnnTensorDescriptor_t input_tensor_desc;
    cudnnTensorDescriptor_t output_tensor_desc;

    cudnnDataType_t inp_datatype;

    const int output_tensor_dims = 4;

    float* d_output;
    float* d_dx;

    int in_N, in_C, in_H, in_W;
    int out_N, out_C, out_H, out_W;
    int n_labels;

    MSELayer(cudnnHandle_t& cudnn_handle_p);
    MSELayer(cudnnHandle_t& cudnn_handle_p,
                 cudnnTensorDescriptor_t input_tensor_desc_p);

    ~MSELayer();

    void propagate_forward(float* d_targ, float* d_x);
    void propagate_backward(float* d_targ, float* d_dx);

private:
    cudnnHandle_t& cudnn_handle;

    static inline unsigned int _ceil(unsigned int nominator, unsigned int denominator) {
        return (nominator + denominator - 1) / denominator;
    }

};


__global__ void compute_mse(const float *labels, const float* x, int num_labels, int batch_size, float* losses);


#endif //CUDNN_PROJ_MSELAYER_H