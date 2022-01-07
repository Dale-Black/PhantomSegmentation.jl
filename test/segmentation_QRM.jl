path = string(cd(pwd, "..") , "/images/Large_rep1")
dcms = dcmdir_parse(path)
dcm_array = load_dcm_array(dcms)
header = dcms[1].meta

@testset ExtendedTestSet "mask_heart" begin
    global masked_array
    global center_insert
    global masked_array
    masked_array, center_insert, mask = mask_heart(
            header, dcm_array, size(dcm_array, 3) ÷ 2
            )
    @testset ExtendedTestSet "mask_heart" begin
        rows, cols = Int(header[(0x0028, 0x0010)]), Int(header[(0x0028, 0x0011)])
        Y, X = collect(1:512), collect(1:512)'
        dist_from_center = @. sqrt((X - center_insert[2])^2 + (Y-center_insert[1])^2)
        answer = dist_from_center .<= 97.3360655737705
        @test mask == answer
    end
end

@testset ExtendedTestSet "get_indices" begin
    global slice_dict
    global large_index
    slice_dict, large_index = get_indices(masked_array, header)
    @testset ExtendedTestSet "get_indices" begin
        answer_dict = Dict(25=>2, 26=>2, 24=>1)
        @test slice_dict == answer_dict
    end

    @testset ExtendedTestSet "get_indices" begin
        answer_index = [10, 11, 12, 13, 14, 15, 16]
        @test large_index == answer_index
    end
end

@testset ExtendedTestSet "find_edges" begin
    global slice_dict2
    global flipped
    global flipped_index
    slice_dict2, flipped, flipped_index = find_edges(masked_array, slice_dict, large_index)
    @testset ExtendedTestSet "find_edges" begin
        answer_dict = Dict(25=>2, 26=>2, 24=>1) 
        @test slice_dict2 == answer_dict
    end
end

@testset ExtendedTestSet "mask_rod" begin
    global calcium_image
    global slice_CCI
    global quality_slice
    global cal_rod_slice
    calcium_image, slice_CCI, quality_slice, cal_rod_slice = mask_rod(masked_array, header)
    @testset ExtendedTestSet "mask_rod" begin
        @test slice_CCI == 25
    end

    @testset ExtendedTestSet "mask_rod" begin
        @test quality_slice == 32
    end

    @testset ExtendedTestSet "mask_rod" begin
        @test cal_rod_slice == 15
    end
end

@testset ExtendedTestSet "calc_output" begin
    global output
    output = calc_output(masked_array, header, slice_CCI)
    @testset ExtendedTestSet "calc_output" begin
        @test output[1] == 8
    end
end

@testset ExtendedTestSet "center_points" begin
    global center
    global center1
    global center2
    global center3
    center, center1, center2, center3 = center_points(dcm_array, output, header, center_insert, slice_CCI)
    @testset ExtendedTestSet "center_points" begin
        @test center == [218, 257]
    end
end

@testset ExtendedTestSet "calc_centers" begin
    dict = calc_centers(dcm_array, output, header, center_insert, slice_CCI)
    @testset ExtendedTestSet "calc_centers" begin
        @test dict[:Large_MD] == [151, 292]
    end
end