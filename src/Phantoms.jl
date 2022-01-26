module Phantoms

using ImageFiltering
using Statistics
using ImageComponentAnalysis
using ImageSegmentation
using DataFrames

include("segmentation_QRM.jl")
include("utils.jl")

export
    # segmentation_QRM.jl
    mask_heart,
    get_calcium_slices,
    get_calcium_center_slices,
    poppable_keys,
    compute_CCI,
    mask_rod,
    calc_output,
    center_points,
    calc_centers,
    mask_inserts,

    # utils.jl 
    find_circle,
    get_pixel_size,
    angle_calc,
    create_circular_mask

end
