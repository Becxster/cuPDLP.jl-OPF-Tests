using PowerModels
using JuMP
using HiGHS

function convert_matpower_to_mps(matpower_file::String, output_mps::String;
        formulation = DCPPowerModel
    )

    # 1. Parse MATPOWER
    data = PowerModels.parse_file(matpower_file)

    # 2. Build OPF model
    model = Model(HiGHS.Optimizer)

    pm = instantiate_model(
        data,
        formulation,
        build_opf,
        jump_model = model
    )

    # 3. Write to MPS
    write_to_file(model, output_mps)
    println("Wrote MPS to: $output_mps")
end

if abspath(PROGRAM_FILE) == @__FILE__
    mat = ARGS[1]
    out = ARGS[2]
    convert_matpower_to_mps(mat, out)
end
