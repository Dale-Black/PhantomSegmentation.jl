path = string(cd(pwd, "..") , "/images/Large_rep1")
dcms = dcmdir_parse(path)
dcm_array = load_dcm_array(dcms)
header = dcms[1].meta
masked_array, center_insert, mask = mask_heart(
            header, dcm_array, size(dcm_array, 3) ÷ 2
            )
slice_dict, large_index = get_indices(masked_array, header)

@testset ExtendedTestSet "mask_heart" begin
    @testset ExtendedTestSet "mask_heart" begin
        rows, cols = Int(header[(0x0028, 0x0010)]), Int(header[(0x0028, 0x0011)])
        Y, X = collect(1:512), collect(1:512)'
        dist_from_center = @. sqrt((X - center_insert[2])^2 + (Y-center_insert[1])^2)
        answer = dist_from_center .<= 97.3360655737705
        @test mask == answer
    end
end

@testset ExtendedTestSet "get_indices" begin
    @testset ExtendedTestSet "get_indices" begin
        answer_dict = Dict(25=>2, 26=>2, 24=>1)
        @test slice_dict == answer_dict
    end

    @testset ExtendedTestSet "get_indices" begin
        answer_index = [10, 11, 12, 13, 14, 15, 16]
        @test large_index == answer_index
    end
end

@testset ExtendedTestSet "get_indices" begin
    @testset ExtendedTestSet "get_indices" begin
        slice_dict2, flipped, flipped_index = find_edges(masked_array, slice_dict, large_index)
        answer_dict = Dict(25=>2, 26=>2, 24=>1) 
        @test slice_dict2 == answer_dict
    end
end

@testset ExtendedTestSet "mask_rod" begin
    slice_dict2, flipped, flipped_index = find_edges(masked_array, slice_dict, large_index)
    @testset ExtendedTestSet "mask_rod" begin
        calcium_image, slice_CCI, quality_slice, cal_rod_slice = mask_rod(masked_array, header)
        @test slice_CCI == 25
    end

    @testset ExtendedTestSet "mask_rod" begin
        calcium_image, slice_CCI, quality_slice, cal_rod_slice = mask_rod(masked_array, header)
        @test quality_slice == 32
    end

    @testset ExtendedTestSet "mask_rod" begin
        calcium_image, slice_CCI, quality_slice, cal_rod_slice = mask_rod(masked_array, header)
        @test cal_rod_slice == 15
    end
end