#include "TrainData.h"

TrainData::TrainData(
        const char* data_f,
        const char* ids_f,
        const char* labels_f,
        size_t batch_size)
:
        Data(data_f, ids_f, batch_size)
{
    _in_f_labels.open(labels_f, std::ifstream::binary);
    if (!_in_f_labels.good())
        throw std::runtime_error("Could not open file with labels");

    lbl_data = (char*) malloc(batch_size);
}

TrainData::~TrainData(){
    _in_f_labels.close();
    free(lbl_data);
}


void TrainData::load_next_batch() {
    int32_t ex_to_read = ((n_examples - n_read) > batch_size )? batch_size
                                                              :(n_examples - n_read);
    int32_t bytes_to_read = ex_to_read * _ex_size_bytes;

    _in_f_data.read( (char*) img_data, bytes_to_read);
    uint bytes_read;
    bytes_read = _in_f_data.gcount();

    if (bytes_read != bytes_to_read)
        throw std::runtime_error("Image data read error");

    _in_f_labels.read( (char*) lbl_data, ex_to_read * sizeof(char) );
    bytes_read = _in_f_labels.gcount();
    if (bytes_read != ex_to_read * sizeof(char))
        throw std::runtime_error("Labels data read error");

    _in_f_ids.read( (char*) ids_data, ex_to_read * sizeof(int32_t) );
    bytes_read = _in_f_ids.gcount();
    if (bytes_read != ex_to_read * sizeof(int32_t))
        throw std::runtime_error("Ids data read error");

    n_read += ex_to_read;
    loaded = ex_to_read;

}