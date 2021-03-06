#ifndef CUDNN_PROJ_NEGLOGLIKELIHOODLAYER_H
#define CUDNN_PROJ_NEGLOGLIKELIHOODLAYER_H

#include "Layer.cuh"


class NegLogLikelihoodLayer: public MetricLayer {
public:
    const int output_tensor_dims = 4;

    float *h_output;

    int n_labels;

    NegLogLikelihoodLayer(cudnnHandle_t& cudnn_handle_p,
             cudnnTensorDescriptor_t input_tensor_desc_p);

    ~NegLogLikelihoodLayer();

    void compute_loss(float *d_targ, float *d_x) override;
    void propagate_forward(float*) override {};
    void propagate_backward(float* d_targ, float* d_y, float momentum = 0.0) override;
    void update_weights(float lr) override {};

private:

    const int BW = 128;

    static inline unsigned int _ceil(unsigned int nominator, unsigned int denominator) {
        return (nominator + denominator - 1) / denominator;
    }

};


__global__ void compute_nll(const float *labels,
                            const float* x,
                            int num_labels,
                            int batch_size,
                            float* losses);

__global__ void compute_nll_grad(const float *labels,
                                 const float* y,
                                 int num_labels,
                                 int batch_size,
                                 float* grad);

#endif //CUDNN_PROJ_NEGLOGLIKELIHOODLAYER_H
